import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/tenant_bottomnavigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;  // Keep track of the selected index

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
      backgroundColor: Colors.white, // White background for the screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture, Name, and Email
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_picture.png'), // Add your profile image asset
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
            Divider(thickness: 1, color: Colors.black),

            // Menu Options with Vintage Shadow
            buildListTile(Icons.person, 'Personal details'),
            SizedBox(height: 15),
            buildListTile(Icons.settings, 'Settings'),
            SizedBox(height: 15),
            buildListTile(Icons.payment, 'Payment details'),
            SizedBox(height: 15),
            buildListTile(Icons.help_outline, 'FAQ'),
            SizedBox(height: 15),
            Divider(thickness: 1, color: Colors.black),
            buildListTile(Icons.switch_account, 'Switch to landlord'),

            SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Log out functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2b82c8),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Log out', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:  TenantBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )
    );
  }

  // Helper function to build ListTile with square icons and vintage shadow effect
  Widget buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Square-ish corners
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Vintage shadow color
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Add functionality for each option here
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
