import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/chat_screen.dart';
import 'package:tolet/screens/owner/home_screen.dart';
import 'package:tolet/screens/owner/list_property.dart';
import 'package:tolet/screens/owner/owner_profile.dart';
import 'package:tolet/screens/owner/tenant_finder.dart';
import 'package:tolet/widgets/constcolor.dart';

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
      selectedItemColor:
          Color(constcolor.App_blue_color), // Set selected item color
      unselectedItemColor: Colors.grey, // Set unselected item color
      type: BottomNavigationBarType.fixed, // Ensure all items are fixed
      currentIndex: currentIndex, // Track the current selected index
      onTap: (index) {
        switch (index) {
          case 0:
            // Navigate to the Home screen
            Get.to(() => HomeScreen(), transition: Transition.fade);

            break;
          case 1:
            Get.to(() => TenantFinderScreen(), transition: Transition.fade);

            // Navigate to the Explore screen
            // Replace with the correct screen if available
            break;
          case 2:
            // Navigate to the Chat screen
            Get.to(() => ListPropertyScreen(), transition: Transition.fade);

            break;
          case 3:
            Get.to(() => ChatScreen(), transition: Transition.fade);

            // Navigate to the Saved screen
            // Replace with the correct screen if available
            break;
          case 4:
            // Navigate to the Profile screen
            Get.to(() => OwnerProfileScreen(), transition: Transition.fade);

            break;
        }
        onTap(index); // Call the onTap function to update the currentIndex
      }, // Track the current selected index
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
            label: 'Requests'),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/add.png', // Make sure the image path is correct
            height: 60, // Adjust icon height
            width: 60, // Adjust icon width
          ),
          icon: Image.asset(
            'assets/icons/add.png', // Make sure the image path is correct
            height: 60, // Adjust icon height
            width: 60, // Adjust icon width
          ), // The "+" icon in the middle
          label: '', // No label for the middle item
        ),
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
              'assets/icons/activeProfile.png', // Make sure the image path is correct
              height: 24, // Adjust icon height
              width: 24, // Adjust icon width
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
