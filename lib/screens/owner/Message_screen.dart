import 'package:flutter/material.dart';

class DetailedChatScreen extends StatelessWidget {
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
              backgroundImage: AssetImage('assets/images/dp.png'),
            ),
            SizedBox(width: 10),
            Text(
              'Bhuban KC',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                MessageTile(
                  message: 'How is the property condition?',
                  time: '14:22',
                  isSentByMe: true,
                  isRead: true,
                ),
                MessageTile(
                  message: 'It’s nice myan for sure.\nYou will love it',
                  time: '14:24',
                  isSentByMe: false,
                ),
                MessageTile(
                  message: 'I see, thanks for informing!',
                  time: '14:28',
                  isSentByMe: true,
                  isRead: true,
                ),
                MessageTile(
                  message: 'Thanks for contacting me!',
                  time: '14:30',
                  isSentByMe: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
              Container(
              width: 30, // Width and height of the circle
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2), // Grey border
                color: Colors.white, // White background
              ),
              child: Icon(Icons.add, color: Colors.grey, size: 20), // Plus icon inside the circle
            ),

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
                          Icon(Icons.message, color: Colors.grey), // Message icon to the left
                          SizedBox(width: 8), // Spacing between the icon and text field
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Type something',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                   // Attachment icon
                                ],
                              ),
                            ),
                          ), // Send icon
                        ],
                      ),
                    ),

                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send, color: Colors.blue),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), // Adds 2 inches of space on both sides
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
                    Icon(Icons.done_all, color: Colors.blue, size: 16), // Double tick
                  SizedBox(height: 2), // Small space between tick and time
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(width: 5), // Space between the time/tick and message bubble
            ],
            // Message bubble (either blue for sent or grey for received) with gradient and shadow
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // Apply gradient
                gradient: LinearGradient(
                  colors: isSentByMe
                      ? [Colors.blue[300]!, Colors.blue[700]!]
                      : [Colors.white!, Colors.grey[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // Apply shadow for a vintage effect
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
                // Border radius for bubble-like shape
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft:
                  isSentByMe ? Radius.circular(20) : Radius.circular(0),
                  bottomRight:
                  isSentByMe ? Radius.circular(0) : Radius.circular(20),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: isSentByMe ? Colors.white : Colors.black),
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
