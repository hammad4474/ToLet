// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tolet/screens/complain.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userName;
  int _totalProperties = 0;

  // Handle bottom navigation taps

  void initState() {
    super.initState();
    _fetchUserData();
    _fectTotalProperties();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['firstname'] ?? 'User';
        });
      }
    }
  }

  Future<void> _fectTotalProperties() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot propertySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('properties')
          .get();

      setState(() {
        _totalProperties = propertySnapshot.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            Center(
              child: Text(
                'Dashboard',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
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
                "Welcome, ${userName?.toUpperCase() ?? 'Loading...'}",
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
                      colors: [Color(0xff50bca3), Color(0xff4bb59c)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Total Property',
                    value: _totalProperties.toString(),
                  ),
                  _buildDashboardCard(
                    gradient: LinearGradient(
                      colors: [Color(0xffeb7a65), Color(0xffdf6048)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Total Bookings',
                    value: '0',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Action Cards (Payment Received and Earn Daily Income)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionCard(
                    assetPath:
                        'assets/icons/PR.png', // Path to your asset image
                    title: 'Payment Received',
                    subtitle: '\$25,001',
                  ),
                  _buildActionCard(
                    assetPath:
                        'assets/icons/EARNING.png', // Path to your asset image
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
      // bottomNavigationBar: CustomBottomNavigationBar(),
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
              color: Colors.white,
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
