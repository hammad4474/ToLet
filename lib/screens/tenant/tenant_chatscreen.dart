import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';
import 'package:tolet/screens/tenant/tenant_messageScreen.dart';

class tenantChatScreen extends StatefulWidget {
  @override
  State<tenantChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<tenantChatScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(30), // Oval shape
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search messages',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none, // No default underline border
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ChatTile(
            name: 'Anil',
            message: 'Thanks for contacting me!',
            time: '15:23',
            unreadMessages: 2,
            avatar:
            'assets/images/dp.png', // Replace with actual avatar URL or asset
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tenantmessagescreen()));
            },
          ),
          ChatTile(
            name: 'Tom Cruise',
            message: 'Your payment was accepted.',
            time: 'Yesterday',
            avatar:
            'assets/Images/delhi.png', // Replace with actual avatar URL or asset
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tenantmessagescreen()));
            },
          ),
          ChatTile(
            name: 'Thomas Selby',
            message: 'It was great experience!',
            time: '11/10/2021',
            avatar:
            'assets/Images/dp.png', // Replace with actual avatar URL or asset
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tenantmessagescreen()));
            },
          ),
          ChatTile(
            name: 'Regnar Lothbrok',
            message: 'How much does it cost?',
            time: '11/10/2021',
            avatar:
            'assets/images/Capture.png', // Replace with actual avatar URL or asset
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tenantmessagescreen()));
            },
          ),
          ChatTile(
            name: 'Jack Sparrow',
            message: 'Sure, man!',
            time: '11/10/2021',
            avatar:
            'assets/images/delhi.png', // Replace with actual avatar URL or asset
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tenantmessagescreen()));
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomtenantBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadMessages;
  final bool read;
  final String avatar;
  final VoidCallback onTap; // Callback for handling the tap

  ChatTile({
    required this.name,
    required this.message,
    required this.time,
    this.unreadMessages = 0,
    this.read = true,
    required this.avatar,
    required this.onTap, // Receive the tap function
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Handle tap with the provided function
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
          AssetImage(avatar), // Replace with actual asset if necessary
          radius: 25,
        ),
        title: Text(name),
        subtitle: Text(message),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: TextStyle(color: Colors.grey)),
            if (unreadMessages > 0)
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
                child: Text(
                  unreadMessages.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        tileColor: read ? Colors.white : Colors.grey[200],
      ),
    );
  }
}
