import 'package:flutter/material.dart';
import 'package:tolet/screens/user_profile.dart';

class CustomtenantBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomtenantBottomNavBar({
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
          activeIcon: Image.asset(
            'assets/icons/homeblue.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ),
          icon: Image.asset(
            'assets/icons/home1.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/icons/activerequest.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            icon: Image.asset(
              'assets/icons/request.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            label: 'Explore'),
        BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/icons/activechat.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            icon: Image.asset(
              'assets/icons/chat.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
            ),
            label: 'Chat'),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/saved.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ),
          icon: Image.asset(
            'assets/icons/saved.png', // Make sure the image path is correct
            height: 24, // Adjust icon height
            width: 24, // Adjust icon width
          ), // The "+" icon in the middle
          label: 'Saved', // No label for the middle item
        ),
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
