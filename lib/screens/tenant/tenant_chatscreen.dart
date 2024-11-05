import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tolet/screens/tenant/tenant_messageScreen.dart';
import 'package:tolet/widgets/constcolor.dart';

class TenantChatScreen extends StatefulWidget {
  @override
  State<TenantChatScreen> createState() => _TenantChatScreenState();
}

class _TenantChatScreenState extends State<TenantChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final tenantId = FirebaseAuth.instance.currentUser?.uid;

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
            controller: _searchController,
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
      body: tenantId != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants.tenant.id', isEqualTo: tenantId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("Error fetching chats: ${snapshot.error}");
                  return Center(child: Text("Error fetching chats."));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print("Snapshot has no data or is empty.");
                  return Center(child: CircularProgressIndicator());
                }

                final chatDocs = snapshot.data!.docs;
                print("Retrieved ${chatDocs.length} chats.");

                final filteredChatDocs = chatDocs.where((doc) {
                  final ownerName = doc['participants']['owner']['name'] ?? '';
                  final lastMessage = (doc['msgs'] as List).isNotEmpty
                      ? doc['msgs'].last['text']
                      : '';
                  return ownerName
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()) ||
                      lastMessage
                          .toLowerCase()
                          .contains(_searchText.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredChatDocs.length,
                  itemBuilder: (context, index) {
                    final chatData =
                        filteredChatDocs[index].data() as Map<String, dynamic>;

                    return ChatTile(
                      name: chatData['participants']['owner']['name'] ?? '',
                      message: (chatData['msgs'] as List).isNotEmpty
                          ? chatData['msgs'].last['text']
                          : '',
                      time: chatData['createdAt'] != null
                          ? (chatData['createdAt'] as Timestamp)
                              .toDate()
                              .toString() // Format time if needed
                          : '',
                      unreadMessages: 0, // Add logic if unread count is stored
                      avatar: 'assets/images/dp.png',
                      onTap: () {
                        // Ensure the correct path to the owner's name
                        final ownerName = chatData['participants']['owner']
                                ['name'] ??
                            'Unknown Owner';

                        Get.to(
                            () => TenantMessageScreen(
                                  chatId: chatData['chatId'],
                                  ownerName: ownerName,
                                ),
                            transition: Transition.fadeIn);
                      },
                    );
                  },
                );
              },
            )
          : Center(child: Text('Tenant not logged in.')),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
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

  String formatTime(String timestamp) {
    // Assuming the timestamp is in a format that DateTime can parse.
    DateTime dateTime = DateTime.parse(timestamp);

    // Extract minutes and seconds
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    String seconds = dateTime.second.toString().padLeft(2, '0');

    return '$minutes:$seconds'; // Format: MM:SS
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(avatar),
          radius: 25,
        ),
        title: Text(
          name.toUpperCase(),
          style:
              TextStyle(color: Color(0xff1a2847), fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formatTime(time), style: TextStyle(color: Color(0xff192747))),
            SizedBox(
              height: Get.height * .01,
            ),
            if (unreadMessages >= 0)
              CircleAvatar(
                radius: 10,
                backgroundColor: Color(constcolor.App_blue_color),
                child: Text(
                  unreadMessages.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        tileColor: unreadMessages > 0 ? Colors.grey[200] : Colors.white,
      ),
    );
  }
}
