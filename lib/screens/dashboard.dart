import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/owner/chat_screen.dart';  // Import your other screens
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/complain.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';  // CustomtenantBottomNavBar file

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Handle bottom navigation taps
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back,color: Colors.black),
            ),
            Text(
              'Dashboard',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.menu,color: Colors.black)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, Anil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Dashboard Cards (Total Property and Total Bookings)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Total Property',
                    value: '8',
                  ),
                  _buildDashboardCard(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Total Bookings',
                    value: '2',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Action Cards (Payment Received and Earn Daily Income)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionCard(
                    assetPath: 'assets/icons/earn.png', // Path to your asset image
                    title: 'Payment Received',
                    subtitle: '\$25,001',
                  ),
                  _buildActionCard(
                    assetPath: 'assets/icons/payment.png', // Path to your asset image
                    title: 'Earn Daily Income',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Complaints List
              ComplaintsSection(),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard({
    required Gradient gradient,
    required String title,
    required String value,
  }) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.42,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient, // Use the gradient instead of solid color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          // Align the value container to the bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 30, // Adjust the width as needed
              height: 30, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.white, // White background for the circle
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14, // Smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color for the value
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action Card Widget (for Payment Received and Earn Daily Income)
  Widget _buildActionCard({
    required String assetPath, // Asset image path
    required String title,
    String? subtitle,
  }) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width * 0.42,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the box
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Soft shadow
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        children: [
          Image.asset(
            assetPath, // Use asset image
            height: 32, // Adjust size of the asset
          ),
          SizedBox(height: 16),
          // Centered text at the bottom
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Center the title text
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center, // Center the subtitle text
            ),
        ],
      ),
    );
  }

  // Complaints List Widget


  // Individual Complaint Item Widget
  Widget _buildComplaintItem(String tenant, String complaint, Color severity) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: severity,
          radius: 10,
        ),
        title: Text(tenant),
        subtitle: Text(complaint),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}

