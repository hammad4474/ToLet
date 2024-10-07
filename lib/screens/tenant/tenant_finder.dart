import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';

void main() {
  runApp(TenantFinderApp());
}

class TenantFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenant Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TenantFinderScreen(),
    );
  }
}

class TenantFinderScreen extends StatefulWidget {
  @override
  State<TenantFinderScreen> createState() => _TenantFinderScreenState();
}

class _TenantFinderScreenState extends State<TenantFinderScreen> {
  int _currentIndex = 0; // Keep track of the selected index

  // List of pages for each BottomNavigationBar item
  final List<Widget> _pages = [
    TenantFinderScreenContent(), // Home Page
    RequestsScreen(), // Requests Page
    AddNewItemScreen(), // Add New Item Page
    ChatScreen(), // Chat Page
    ProfileScreen(), // Profile Page
  ];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text(
          'Rentaxo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped, // Update the selected index when tapped
      ),
    );
  }
}

// Separate widget for Tenant Finder content (Home Page)
class TenantFinderScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tenant Finder',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Find perfect tenant for your property!',
            style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                TenantCard(
                  name: 'Krishna Prasad',
                  avatarUrl: 'assets/Images/Capture.png', // Replace with actual image link or asset
                  propertyType: 'Apartment',
                  location: 'Hyderabad',
                  time: '14 min',
                ),
                TenantCard(
                  name: 'Rakesh Patel',
                  avatarUrl: 'assets/Images/Capture.png', // Replace with actual image link or asset
                  propertyType: 'House',
                  location: 'Faridabad',
                  time: '14 min',
                ),
                TenantCard(
                  name: 'Rashmika Gupta',
                  avatarUrl: 'assets/Images/Capture.png', // Replace with actual image link or asset
                  propertyType: 'Room',
                  location: 'Pune',
                  time: '14 min',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TenantCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String propertyType;
  final String location;
  final String time;

  TenantCard({
    required this.name,
    required this.avatarUrl,
    required this.propertyType,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Color(0xFFE4F7FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
          children: [
            // Row for avatar, name, and time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(avatarUrl), // Avatar image
                ),
                SizedBox(width: 16), // Space between avatar and name
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20, // Increase font size if necessary
                    ),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 12), // Space between the row and the below content
            // Property type and location
                Text(
                  'Looking for, $propertyType',
                  style: TextStyle(color: Colors.grey[700]),
                ),
            SizedBox(height: 4),Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'in $location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Spacer(), // This will push the button to the end of the row
                Container(
                  height: 30,
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle view action
                    },
                    child: Text(
                      'View',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for other screens
class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Requests Page"),
    );
  }
}

class AddNewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Add New Item Page"),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Chat Page"),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Profile Page"),
    );
  }
}
