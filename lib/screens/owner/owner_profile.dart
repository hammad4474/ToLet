import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'package:tolet/widgets/constcolor.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({Key? key}) : super(key: key);
  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  int _selectedIndex = 4; // Keep track of the selected index

  // Function to handle tap on navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add logic here for navigation or any other action
  }

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
      ),
      backgroundColor: Colors.white, // White background for the screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture, Name, and Email
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    // backgroundImage: AssetImage(
                    //     'assets/images/Capture.png'), // Your profile image asset
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Anil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'anil.tolet@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: 5),

            // Menu Options with proper asset icons
            buildListTile('assets/icons/frame.png', 'Personal details',
                isBold: true),
            SizedBox(height: 15),
            buildListTile('assets/icons/setting-2.png', 'Settings',
                isBold: true),
            SizedBox(height: 15),
            buildListTile('assets/icons/card.png', 'Payment details',
                isBold: true),
            SizedBox(height: 15),
            buildListTile('assets/icons/message-question.png', 'FAQ',
                isBold: true),
            SizedBox(height: 25),
            Divider(thickness: 1, color: Colors.grey),
            buildListTile(
                'assets/icons/toggle-off-circle.png', 'Switch to landlord',
                isBold: true),

            SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffADD8E6),
                        Color(constcolor.App_blue_color)
                      ], // Light blue to dark blue
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                      } catch (e) {
                        print("Error signing out: $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Log out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Single definition of buildListTile with optional isBold parameter
  Widget buildListTile(String assetPath, String title, {bool isBold = false}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Rounded square corners
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Shadow for the vintage effect
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding for icon size
          child: Image.asset(assetPath), // Load icon from assets
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isBold
              ? FontWeight.bold
              : FontWeight.normal, // Apply bold if specified
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Add functionality for each option here
      },
    );
  }
}
