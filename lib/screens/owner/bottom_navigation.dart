import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/chat_screen.dart';
import 'package:tolet/screens/owner/home_screen.dart';
import 'package:tolet/screens/owner/list_property.dart';
import 'package:tolet/screens/tenant/tenant_finder.dart';
import 'package:tolet/screens/user_profile.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white, // Set the background color to black
      selectedItemColor: Colors.blue, // Set selected item color
      unselectedItemColor: Colors.grey, // Set unselected item color
      type: BottomNavigationBarType.fixed, // Ensure all items are fixed
      currentIndex: currentIndex, // Track the current selected index
      onTap: onTap, // Handle item taps
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: InkWell(
        onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()));
    },
          child: Image.asset(
            'assets/icons/homeblue.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ),
    ),
          icon: Image.asset(
            'assets/icons/home1.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            activeIcon:InkWell(
              onTap: () {
                Navigator.push(
                    context,
              MaterialPageRoute(
                builder: (context) => TenantFinderScreen()));
                },
              child: Image.asset(
              'assets/icons/activerequest.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            ),
            icon: Image.asset(
              'assets/icons/request.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            label: 'Requests'),
        BottomNavigationBarItem(
          activeIcon: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListPropertyScreen()));
            },
            child: Image.asset(
              'assets/icons/add.png', // Make sure the image path is correct
              height: 60, // Adjust icon height
              width: 60, // Adjust icon width
            ),
          ),
          icon: Image.asset(
            'assets/icons/add.png', // Make sure the image path is correct
            height: 60, // Adjust icon height
            width: 60, // Adjust icon width
          ), // The "+" icon in the middle
          label: '', // No label for the middle item
        ),
        BottomNavigationBarItem(
            activeIcon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              child:Image.asset(
              'assets/icons/activechat.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
    ),
            icon:Image.asset(
                'assets/icons/chat.png', // Make sure the image path is correct
                height: 24, // Adjust icon height
                width: 24, // Adjust icon width
              ),
            label: 'Chat'),
        BottomNavigationBarItem(
            activeIcon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Image.asset(
                'assets/icons/activeProfile.png', // Make sure the image path is correct
                height: 24, // Adjust icon height
                width: 24, // Adjust icon width
              ),
            ),
            icon: Image.asset(
              'assets/icons/profile.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            label: 'Profile'),
      ],
    );
  }
}
