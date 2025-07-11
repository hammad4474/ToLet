import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tolet/screens/owner/ownerdashboard.dart';
import 'package:tolet/screens/owner/dashboard.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'package:tolet/widgets/constcolor.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({Key? key}) : super(key: key);
  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  //int _selectedIndex = 4;
  User? currentUser;
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        userName = userDoc.get('firstname');
        userEmail = currentUser.email ?? 'No Email';
      });
    }
  } // Keep track of the selected index

  // Function to handle tap on navigation items
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   }
  //);
  // Add logic here for navigation or any other action
  // }
  // Future<void> _logout() async {
  //   try {
  //     // Sign out from Firebase
  //     await FirebaseAuth.instance.signOut();

  //     // Clear shared preferences except for `isFirstTime`
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.remove('isLoggedIn');
  //     await prefs.remove('userType');

  //     // Navigate to the Welcome screen
  //     Get.offAll(() => WelcomeScreen(), transition: Transition.fadeIn);
  //   } catch (e) {
  //     print("Error signing out: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
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
                    userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: 5),

            // Menu Options with proper asset icons
            buildListTile(
                () => Get.to(() => DashboardScreen(),
                    transition: Transition.fade),
                'assets/icons/frame.png',
                'Personal details',
                isBold: true),
            SizedBox(height: 15),
            buildListTile(() => (), 'assets/icons/setting-2.png', 'Settings',
                isBold: true),
            SizedBox(height: 15),
            buildListTile(() => (), 'assets/icons/card.png', 'Payment details',
                isBold: true),
            SizedBox(height: 15),
            buildListTile(() => (), 'assets/icons/message-question.png', 'FAQ',
                isBold: true),
            SizedBox(height: 25),
            Divider(thickness: 1, color: Colors.grey),
            // buildListTile(
            //     'assets/icons/toggle-off-circle.png', 'Switch to landlord',
            //     isBold: true),

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
                        Color(0xff192760), // Correct way to create a Color
                        Color(
                            0xff192747), // Use the actual color value for App_blue_color
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

                        // Clear all shared preferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                      } catch (e) {
                        print("Error signing out: $e");
                      }
                    },
                    // _logout,

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
      //bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  // Single definition of buildListTile with optional isBold parameter
  Widget buildListTile(VoidCallback? onTap, String assetPath, String title,
      {bool isBold = false}) {
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
      onTap: onTap,
    );
  }
}
