import 'package:flutter/material.dart';

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
      selectedItemColor: Colors.black, // Set selected item color
      unselectedItemColor: Colors.grey, // Set unselected item color
      type: BottomNavigationBarType.fixed, // Ensure all items are fixed
      currentIndex: currentIndex, // Track the current selected index
      onTap: onTap, // Handle item taps
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Requests'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 40), // The "+" icon in the middle
          label: '', // No label for the middle item
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
