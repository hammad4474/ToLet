import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class TenantMessageScreen extends StatefulWidget {
  final String chatId;
  final String ownerName;

  TenantMessageScreen({required this.chatId, required this.ownerName});

  @override
  _TenantMessageScreenState createState() => _TenantMessageScreenState();
}

class _TenantMessageScreenState extends State<TenantMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });

    // Listen for incoming notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingNotification(message);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleIncomingNotification(RemoteMessage message) async {
    if (message.data['action'] == 'audio_call') {
      String chatId = message.data['chatId'];

      // Show dialog for Accept/Reject
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Incoming Audio Call"),
            content: Text("Do you want to accept the call?"),
            actions: [
              TextButton(
                onPressed: () {
                  // Reject the call
                  FirebaseFirestore.instance
                      .collection('callResponses')
                      .doc(chatId)
                      .set({'response': 'reject'});
                  Navigator.pop(context);
                },
                child: Text("Reject"),
              ),
              TextButton(
                onPressed: () {
                  // Accept the call
                  FirebaseFirestore.instance
                      .collection('callResponses')
                      .doc(chatId)
                      .set({'response': 'accept'});
                  Navigator.pop(context);

                  // Navigate to the Zego audio call screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZegoUIKitPrebuiltCall(
                        appID: 2042440916, // Replace with your actual AppID
                        appSign:
                            'ebe358c62a0e1ebb8313993f0f0b350c077b8d2bb6dd89666c959cb1d0a9119b', // Replace with your AppSign
                        userID: FirebaseAuth.instance.currentUser?.uid ?? '',
                        userName: widget.ownerName,
                        callID: chatId,
                        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
                      ),
                    ),
                  );
                },
                child: Text("Accept"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final tenantId = FirebaseAuth.instance.currentUser?.uid;
    final uniqueMessageId = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc()
        .id;

    final messageData = {
      'id': uniqueMessageId,
      'text': _messageController.text,
      'sentBy': tenantId,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(uniqueMessageId)
          .set(messageData);

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': _messageController.text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'lastMessageSentBy': tenantId,
      });
      _messageController.clear();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            RandomAvatar(widget.ownerName, height: 40, width: 40),
            SizedBox(width: 10),
            Text(
              widget.ownerName.toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Color(0xff1c2746)),
            onPressed: () => _handleIncomingNotification(
              RemoteMessage(
                  data: {'action': 'audio_call', 'chatId': widget.chatId}),
            ),
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
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('No messages yet.'));
                }

                List<MessageTile> messages = [];
                final data = snapshot.data?.docs ?? [];

                for (var msg in data) {
                  messages.add(MessageTile(
                    message: msg['text'],
                    //  timestamp: msg['timestamp'] as Timestamp?,
                    isSentByMe:
                        msg['sentBy'] == FirebaseAuth.instance.currentUser?.uid,
                    isRead: msg['isRead'] ?? false,
                  ));
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView(
                  controller: _scrollController,
                  children: messages,
                );
              },
            ),
          ),
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
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type something',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xff1a2847)),
                  onPressed: _sendMessage,
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
  final Timestamp? timestamp;
  final bool isSentByMe;
  final bool isRead;

  MessageTile({
    required this.message,
    this.timestamp,
    this.isSentByMe = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    //String time = 'Just now';
    if (timestamp != null) {
      final DateTime dateTime = timestamp!.toDate();
      //time = DateFormat('HH:mm').format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isSentByMe) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isRead ? Icons.done_all : Icons.done,
                    color: Color(0xff192747),
                    size: 16,
                  ),
                  SizedBox(height: 2),
                ],
              ),
              SizedBox(width: 5),
            ],
            Flexible(
              child: Container(
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
                    bottomLeft: Radius.circular(isSentByMe ? 10 : 0),
                    bottomRight: Radius.circular(isSentByMe ? 0 : 10),
                  ),
                  border: Border.all(
                    color: isSentByMe ? Color(0xff1a2847) : Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: isSentByMe ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 3),
                    // Text(
                    //   time,
                    //   style: TextStyle(
                    //     color: isSentByMe ? Colors.white70 : Colors.black54,
                    //     fontSize: 12.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
