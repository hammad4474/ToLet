import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/chat_screen.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/tenant/tenant_chatscreen.dart';
//import 'package:tolet/screens/tenant/tenant_finder.dart';
import 'package:tolet/screens/user_profile.dart';
import 'package:tolet/widgets/constcolor.dart';

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
      backgroundColor: Colors.white, // Set the background color
      selectedItemColor: Color(constcolor.App_blue_color), // Set selected item color
      unselectedItemColor: Colors.grey, // Set unselected item color
      type: BottomNavigationBarType.fixed, // Ensure all items are fixed
      currentIndex: currentIndex, // Track the current selected index
      onTap: (index) {
        switch (index) {
          case 0:
          // Navigate to the Home screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HometenantScreen()));
            break;
          case 1:
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => tenantChatScreen()));
          // Navigate to the Explore screen
          // Replace with the correct screen if available
            break;
          case 2:
          // Navigate to the Chat screen
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => tenantChatScreen()));
            break;
          case 3:
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => tenantChatScreen()));
          // Navigate to the Saved screen
          // Replace with the correct screen if available
            break;
          case 4:
          // Navigate to the Profile screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen()));
            break;
        }
        onTap(index); // Call the onTap function to update the currentIndex
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/homeblue.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/home1.png',
            height: 24,
            width: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activerequest.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/request.png',
            height: 24,
            width: 24,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activechat.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/chat.png',
            height: 24,
            width: 24,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/saved.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/saved.png',
            height: 24,
            width: 24,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activeProfile.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/profile.png',
            height: 24,
            width: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
