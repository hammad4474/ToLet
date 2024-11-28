import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:tolet/screens/owner/Message_screen.dart';
import 'package:random_avatar/random_avatar.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search messages',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icons/search-normal.png',
                  width: 24,
                  height: 24,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ),
      body: ownerId != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants.owner.id', isEqualTo: ownerId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final chatDocs = snapshot.data!.docs;

                // Debugging: Check if chatDocs has any documents
                print('Number of chat documents: ${chatDocs.length}');

                if (chatDocs.isEmpty) {
                  return Center(child: Text('No chats found for this owner.'));
                }

                // Filter chats based on search input
                final filteredChatDocs = chatDocs.where((doc) {
                  final tenantName =
                      doc['participants']['tenant']['name'] ?? '';
                  return tenantName
                      .toLowerCase()
                      .contains(_searchText.toLowerCase());
                }).toList();

                // Debugging: Check the number of filtered chats
                print(
                    'Number of filtered chat documents: ${filteredChatDocs.length}');

                return ListView.builder(
                  itemCount: filteredChatDocs.length,
                  itemBuilder: (context, index) {
                    final chatData =
                        filteredChatDocs[index].data() as Map<String, dynamic>;
                    final chatId = chatData['chatId'];
                    final tenantName =
                        chatData['participants']['tenant']['name'] ?? 'Unknown';

                    // Initialize the last message and time variables
                    String lastMessage = chatData['lastMessage'] ?? '';
                    String time = '';

                    // Check if msgs field exists and is not empty
                    if (chatData['msgs'] != null &&
                        (chatData['msgs'] as List).isNotEmpty) {
                      final lastMsg =
                          chatData['msgs'].last as Map<String, dynamic>;

                      // Get the last message text if it exists
                      lastMessage = lastMsg['text'] ?? 'No messages yet';

                      // Get the timestamp if it exists, format it correctly
                      if (lastMsg['sentAt'] != null) {
                        time = (lastMsg['sentAt'] as Timestamp)
                            .toDate()
                            .toString();
                      } else if (chatData['createdAt'] != null) {
                        time = (chatData['createdAt'] as Timestamp)
                            .toDate()
                            .toString();
                      }
                    }

                    final avatar = chatData['participants']['tenant']
                            ['avatar'] ??
                        'assets/images/dp.png';

                    return ChatTile(
                      name: tenantName,
                      message: chatData['lastMessage'] ?? '',
                      time: time,
                      avatar: avatar,
                      onTap: () {
                        Get.to(
                          () => DetailedChatScreen(
                            chatId: chatId,
                            tenantName: tenantName,
                            avatar: avatar,
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                    );
                  },
                );
              })
          : Center(child: Text('Owner not logged in.')),
    );
  }
}

// The ChatTile class remains the same as in your original .

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final dynamic time;
  final int unreadMessages;
  final String avatar;
  final VoidCallback onTap;

  ChatTile({
    required this.name,
    required this.message,
    required this.time,
    this.unreadMessages = 0,
    required this.avatar,
    required this.onTap,
  });

  String formatTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      String hours = dateTime.hour.toString().padLeft(2, '0');
      String minutes = dateTime.minute.toString().padLeft(2, '0');
      return '$hours:$minutes'; // Format: HH:MM
    } else if (timestamp is String) {
      try {
        DateTime dateTime = DateTime.parse(timestamp);
        String hours = dateTime.hour.toString().padLeft(2, '0');
        String minutes = dateTime.minute.toString().padLeft(2, '0');
        return '$hours:$minutes';
      } catch (e) {
        return 'Invalid date';
      }
    } else {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use RandomAvatar if avatar is not provided
    final avatarWidget = avatar == 'assets/images/dp.png'
        ? RandomAvatar(
            name, // Use tenant's name or any other identifier
            height: 50,
            width: 50,
            trBackground: true, // For transparent background
          )
        : CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 25,
          );

    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: avatarWidget, // Use the generated avatar
        title: Text(
          name.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the time above the unread messages count
            Text(formatTime(time), style: TextStyle(color: Color(0xff192747))),
            const SizedBox(
                height: 4), // Add space between time and unread messages
            if (unreadMessages >= 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadMessages.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
