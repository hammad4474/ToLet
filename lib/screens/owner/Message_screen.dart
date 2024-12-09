import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tolet/auth/call_screen.dart';
import 'package:tolet/services/get_services_key.dart';
import 'package:tolet/widgets/constcolor.dart';

class DetailedChatScreen extends StatefulWidget {
  final String chatId;
  final String tenantName; // Accept chatId as a parameter
  final String avatar; // Add avatar field

  DetailedChatScreen(
      {required this.chatId, required this.tenantName, required this.avatar});

  @override
  _DetailedChatScreenState createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  String _currentUserId = '';

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose(); // Dispose of the message controller
    _scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final ownerId = FirebaseAuth.instance.currentUser?.uid;
    final uniqueMessageId = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc()
        .id;

    final messageData = {
      'id': uniqueMessageId,
      'text': _messageController.text,
      'sentBy': ownerId,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(), // Add timestamp directly
    };

    try {
      // Add the message to the sub-collection "messages"
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(uniqueMessageId)
          .set(messageData);

      // Increment unread message count for tenant in the main chat document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': _messageController.text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'lastMessageSentBy': ownerId,
      });
      _messageController.clear();

      // Scroll to the bottom after sending a message
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _startAudioCall() async {
    String callID = widget.chatId; // Use chatId as the unique call ID
    String ownerId = _currentUserId;

    try {
      // Send a message to the chat notifying the other user of the incoming call
      await _sendCallMessage(callID, ownerId);

      // Send a notification to the tenant (the other user)
      await NotificationServices.sendCallNotification(
        tenantId: widget.chatId, // Tenant ID or token
        title: "Incoming Call",
        body: "${widget.tenantName}, you have an incoming audio call",
        data: {
          'action': 'audio_call',
          'chatId': callID,
          'senderId': ownerId,
          'callType': 'audio',
        },
      );

      // Immediately navigate to the call screen after sending the message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioCallScreen(
            callID: callID,
            isOwner:
                true, // Indicating that the current user is the call initiator (owner)
          ),
        ),
      );
    } catch (e) {
      print("Error starting audio call: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to initiate call")),
      );
    }
  }

// Method to send a message to the Firestore chat about the call
  Future<void> _sendCallMessage(String chatId, String senderId) async {
    final uniqueMessageId = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc()
        .id;

    final callMessageData = {
      'id': uniqueMessageId,
      'text': "You have an incoming call, please join.",
      'sentBy': senderId,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(), // Add timestamp directly
    };

    try {
      // Add the message to the sub-collection "messages"
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(uniqueMessageId)
          .set(callMessageData);

      // Optionally, update the main chat document
      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': "Incoming call notification",
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'lastMessageSentBy': senderId,
      });
    } catch (e) {
      print("Error sending call message: $e");
    }
  }

  // void _startAudioCall() {
  //   String callID = widget.chatId; // Use chatId as the unique call ID

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AudioCallScreen(
  //         callID: callID,
  //         isOwner: true, // Set to true for the owner
  //         // roomId: callID,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Row(
          children: [
            // Use RandomAvatar widget here for dynamic avatar generation
            RandomAvatar(
              widget.tenantName,
              height: 40, // Set height for the avatar
              width: 40, // Set width for the avatar
              trBackground: true, // Transparent background for the avatar
            ),
            SizedBox(width: 10),
            Text(
              widget.tenantName.toUpperCase(), // Tenant name
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Color(0xff1c2746)), // Call icon
            onPressed: _startAudioCall,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatId)
                .collection('messages')
                .orderBy('timestamp',
                    descending: false) // Show latest messages at the bottom
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              // Create list of MessageTile widgets from Firestore data
              List<MessageTile> messages = snapshot.data!.docs.map((doc) {
                final msg = doc.data() as Map<String, dynamic>;
                return MessageTile(
                  message: msg['text'] ?? '',
                  time: (msg['timestamp'] as Timestamp?)
                          ?.toDate()
                          .toLocal()
                          .toString() ??
                      'Just now', // Format timestamp
                  isSentByMe:
                      msg['sentBy'] == FirebaseAuth.instance.currentUser?.uid,
                  isRead: msg['isRead'] ?? false,
                );
              }).toList();

              // Auto-scroll to the bottom after a new message is added
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView(
                controller: _scrollController, // Attach ScrollController
                children: messages,
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.message,
                              color: Colors.grey), // Message icon to the left
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type something',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon:
                      Icon(Icons.send, color: Color(constcolor.App_blue_color)),
                  onPressed: () {
                    _sendMessage(); // Send message when pressed
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByMe;
  final bool isRead;
  final String avatar;

  MessageTile({
    required this.message,
    required this.time,
    this.isSentByMe = false,
    this.isRead = false,
    this.avatar = 'assets/images/dp.png', // Default avatar if none provided
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isSentByMe) ...[
              // Double tick for sent messages, placed to the left of the text
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isRead)
                    Icon(Icons.done_all, color: Color(0xff192747), size: 16)
                  else
                    Icon(Icons.done, color: Color(0xff192747), size: 16),
                  SizedBox(height: 2),
                ],
              ),
              SizedBox(width: 5), // Space between tick icon and message text
            ],
            // Message bubble with gradient and shadow
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSentByMe
                        ? [Color(0xff1a2847), Color(0xff192747)]
                        : [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft:
                        isSentByMe ? Radius.circular(10) : Radius.circular(0),
                    bottomRight:
                        isSentByMe ? Radius.circular(0) : Radius.circular(10),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationServices {
  static Future<void> sendCallNotification({
    required String tenantId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    // Use Firebase Cloud Messaging to send notification
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'to': tenantId, // Tenant's device token or user ID
        'title': title,
        'body': body,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
