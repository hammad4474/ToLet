import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tolet/auth/call_screen.dart';
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

  String get callID => widget.chatId;

  @override
  void initState() {
    super.initState();

    // Focus node listener
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.isEmpty) return;

    final tenantId = FirebaseAuth.instance.currentUser?.uid;
    final uniqueMessageId = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc()
        .id;

    final messageData = {
      'id': uniqueMessageId,
      'text': messageText,
      'sentBy': tenantId,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Send message to Firestore
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(uniqueMessageId)
          .set(messageData);

      // Update last message in the chat document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': messageText,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'lastMessageSentBy': tenantId,
      });
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
            onPressed: () async {
              // Step 1: Send a message to the other user about the incoming call
              await _sendMessage("You have an incoming call. Please join.");

              // Step 2: Navigate to the call screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioCallScreen(
                    callID: callID, // Pass the call ID (chat ID)
                    isOwner: false, // Tenant is not the owner
                  ),
                ),
              );
            },
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
                  onPressed: () async {
                    await _sendMessage(_messageController.text);
                    _messageController.clear();
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
    if (timestamp != null) {
      final DateTime dateTime = timestamp!.toDate();
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
