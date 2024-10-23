import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/screens/tenant/tenant_messageScreen.dart';
import 'package:tolet/widgets/constcolor.dart';

class tenantChatScreen extends StatefulWidget {
  @override
  State<tenantChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<tenantChatScreen> {
  // int _selectedIndex = 2;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
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
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/icons/search-normal.png', // Replace with your actual asset path
                  width: 24,
                  height: 24,
                ),
              ),
              border: InputBorder.none, // No default underline border
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          )
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
              Get.to(() => tenantmessagescreen(), transition: Transition.fade);
            },
          ),
          ChatTile(
            name: 'Tom Cruise',
            message: 'Your payment was accepted.',
            time: 'Yesterday',
            avatar:
                'assets/Images/delhi.png', // Replace with actual avatar URL or asset
            onTap: () {
              Get.to(() => tenantmessagescreen(), transition: Transition.fade);
            },
          ),
          ChatTile(
            name: 'Thomas Selby',
            message: 'It was great experience!',
            time: '11/10/2021',
            avatar:
                'assets/Images/dp.png', // Replace with actual avatar URL or asset
            onTap: () {
              Get.to(() => tenantmessagescreen(), transition: Transition.fade);
            },
          ),
          ChatTile(
            name: 'Regnar Lothbrok',
            message: 'How much does it cost?',
            time: '11/10/2021',
            avatar:
                'assets/images/Capture.png', // Replace with actual avatar URL or asset
            onTap: () {
              Get.to(() => tenantmessagescreen(), transition: Transition.fade);
            },
          ),
          ChatTile(
            name: 'Jack Sparrow',
            message: 'Sure, man!',
            time: '11/10/2021',
            avatar:
                'assets/images/delhi.png', // Replace with actual avatar URL or asset
            onTap: () {
              Get.to(() => tenantmessagescreen(), transition: Transition.fade);
            },
          ),
          SizedBox(height: 20), // Space between the TextField and the button
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous screen
            },
            child: Text(
              'Back',
              style: TextStyle(fontSize: 15,color: Colors.grey), // Adjust the text size
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Add padding
            ),
          ),
        ],
      ),
      // bottomNavigationBar: CustomtenantBottomNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
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
            Text(time, style: TextStyle(color: Color(0xff192747))),
            if (unreadMessages > 0)
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
        tileColor: read ? Colors.white : Colors.grey[200],
      ),
    );
  }
}
