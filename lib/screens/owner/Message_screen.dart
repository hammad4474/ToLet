import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tolet/widgets/constcolor.dart';

class DetailedChatScreen extends StatefulWidget {
  final String chatId;
  final String tenantName; // Accept chatId as a parameter

  DetailedChatScreen({required this.chatId, required this.tenantName});

  @override
  _DetailedChatScreenState createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  void dispose() {
    _messageController.dispose(); // Dispose of the message controller
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final ownerId = FirebaseAuth.instance.currentUser?.uid;
    final messageData = {
      'text': _messageController.text,
      'sentBy': ownerId,
      'isRead': false,
    };

    _messageController.clear();
    try {
      // Step 1: Add the message without the timestamp
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'msgs': FieldValue.arrayUnion([messageData]),
      });

      // Step 2: Update the last message to include the timestamp
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'msgs': FieldValue.arrayUnion([
          {
            ...messageData,
            'timestamp': FieldValue.serverTimestamp(), // Now add timestamp here
          }
        ]),
      });
    } catch (e) {
      print("Error sending message: $e");
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
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/dp.png'), // Placeholder avatar
            ),
            SizedBox(width: 10),
            Text(
              widget.tenantName
                  .toUpperCase(), // Replace with tenant's name fetched from Firestore
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No messages yet.'));
                }

                // Extract messages from Firestore data
                List<MessageTile> messages = [];
                final data = snapshot.data?['msgs'] as List<dynamic>?;

                if (data != null) {
                  for (var msg in data) {
                    messages.add(MessageTile(
                      message: msg['text'],
                      time: (msg['timestamp'] as Timestamp?)
                              ?.toDate()
                              .toLocal()
                              .toString() ??
                          'Just now', // Convert timestamp
                      isSentByMe: msg['sentBy'] == _currentUserId,
                      isRead: msg['isRead'] ?? false,
                    ));
                  }
                }

                return ListView(
                  children: messages, // Display fetched messages here
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Container(
                //   width: 30, // Width and height of the circle
                //   height: 30,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border:
                //         Border.all(color: Colors.grey, width: 2), // Grey border
                //     color: Colors.white, // White background
                //   ),
                //   child: Icon(Icons.add,
                //       color: Colors.grey,
                //       size: 20), // Plus icon inside the circle
                // ),
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
                          SizedBox(
                              width:
                                  8), // Spacing between the icon and text field
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

  MessageTile({
    required this.message,
    required this.time,
    this.isSentByMe = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    String time = 'Just now'; // Default time

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30.0), // Adds space on both sides
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isSentByMe) ...[
              // Double tick above the time for sent messages
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isRead)
                    Icon(Icons.done_all,
                        color: Color(0xff192747),
                        size: 16) // Double tick for read
                  else
                    Icon(Icons.done,
                        color: Color(0xff192747),
                        size: 16), // Single tick for sent
                  SizedBox(height: 2), // Small space between tick and time
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(
                  width: 5), // Space between the time/tick and message bubble
            ],
            // Message bubble with gradient and shadow
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSentByMe
                      ? [Color(0xff1a2847)!, Color(0xff192747)]
                      : [Colors.white!, Colors.white!],
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
                style:
                    TextStyle(color: isSentByMe ? Colors.white : Colors.black),
              ),
            ),
            if (!isSentByMe) ...[
              // Time for received messages on the right side
              SizedBox(width: 5), // Space between message bubble and time/tick
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
