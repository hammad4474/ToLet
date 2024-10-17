import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tolet/screens/appbarScreens/home_appbar.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/owner/list_property.dart';
import 'package:tolet/screens/owner/properties_panel.dart';
import 'package:tolet/widgets/constcolor.dart';

import '../popup_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  const HomeScreen({super.key});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocation = 'Hyderabad';

  //int selectedRoleIndex = 0; // 0 for Owner, 1 for Tenant
  int _selectedIndex = 0; // Keep track of the selected index
  final List<Map<String, String>> cities = [
    {'name': 'Bangalore', 'image': 'assets/images/bangalore.png'},
    {'name': 'Hyderabad', 'image': 'assets/images/Hyderabad.png'},
    {'name': 'Gurgaon', 'image': 'assets/images/Gurgaon.png'},
    {'name': 'Chennai', 'image': 'assets/images/chennai.png'},
    {'name': 'Mumbai', 'image': 'assets/images/mumbai.png'},
    {'name': 'Pune', 'image': 'assets/images/pune.png'},
    {'name': 'Noida', 'image': 'assets/images/noida.png'},
    {'name': 'Greater Noida', 'image': 'assets/images/Greaternoida.png'},
    {'name': 'Delhi', 'image': 'assets/images/delhi.png'},
    {'name': 'Ghaziabad', 'image': 'assets/images/gaziabad.png'},
    {'name': 'Faridabad', 'image': 'assets/images/faridabad.png'},
    {'name': 'Ahmedabad', 'image': 'assets/images/ahmedabad.png'},
  ];

  // Function to handle tap on navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add logic here for navigation or any other action
  }

  void _setSelectedCity(String city) {
    setState(() {
      _selectedLocation = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar:
              HomeAppBar(onTuneIconPressed: () {}, onSearchBarTapped: () {}),
          body: Container(
            color: Colors.white, // Set your desired background color here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Selector
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  // Adjust padding as needed
                  child: Text(
                    'Your current locations',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors
                          .grey[600], // Optional: color for a subtle appearance
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(
                          0.5), // Transparent background with opacity
                      builder: (BuildContext context) => Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: 450,
                              maxHeight: 600), // Limit dialog width
                          child: CitySelectionDialog(
                            cities: cities,
                            onCitySelected:
                                _setSelectedCity, // Pass the callback function
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          _selectedLocation + ', India',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                ),

                // Role Selector (Switchable)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  // Adjust padding as needed
                  child: Text(
                    'Welcome to Owner',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors
                          .black, // Optional: color for a subtle appearance
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50, // Height for the outer grey container
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors
                          .grey[200], // Background color for the entire row
                      borderRadius: BorderRadius.circular(
                          30), // Rounded corners for the entire container
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            //width: 100, // Set width as a percentage of the screen width
                            //height: 38, // Smaller height for the blue container
                            margin: const EdgeInsets.all(
                                7.5), // Center the smaller button vertically
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              gradient: LinearGradient(
                                colors: [
                                  Color(constcolor.App_lightblue_color),
                                  Color(constcolor.App_blue_color)
                                ], // Gradient for selected button
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Owner',
                                style: TextStyle(
                                  color: Colors
                                      .white, // Text color for highlighted button
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Owner Button (Inactive)
                        Expanded(
                          child: Container(
                            // Slightly smaller height for the inactive button
                            margin: const EdgeInsets.all(
                                7.5), // Center the smaller button vertically
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors
                                  .transparent, // Background color for unselected button
                            ),
                            child: Center(
                              child: Text(
                                'Tenant',
                                style: TextStyle(
                                  color: Colors
                                      .grey, // Text color for unselected button
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tenant Button (Active)
                      ],
                    ),
                  ),
                ),
                // Property ListView
                Expanded(
                  child: ListView(
                    children: [
                      _buildPropertyCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPropertyScreen()));
                        },
                        context: context,
                        imageUrl: 'assets/images/home0.png',
                        // Replace with actual image
                        title: 'Want to host your new place?',
                        description:
                            'Post and manage rental listings & generate revenue from both long-term leases and daily rentals.',
                        buttonText: 'List New Property',
                      ),
                      SizedBox(height: 10), // Space between cards
                      _buildPropertyCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PropertiesPanel()));
                        },
                        context: context,
                        imageUrl: 'assets/images/home1.png',
                        // Replace with actual image
                        title: 'Earn Daily Income',
                        description:
                            'Rent out your property for short-term stays and start earning daily. Manage bookings, track earnings, and maximize your revenue.',
                        buttonText: 'See Your Property',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          )),
    );
  }

  Widget _buildPropertyCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap, // Call the onTap callback here
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        child: Container(
          height: screenHeight * 0.35, // Set height based on screen size
          child: Row(
            children: [
              // Left section (Text and Button with gradient background)
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  // Padding proportional to screen size
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(constcolor.App_lightblue_color), Color(constcolor.App_blue_color)],
                      // Blue gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          // Adjust font size based on screen width
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenWidth *
                              0.025, // Adjust description font size
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      // Adjust spacing based on screen size
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(constcolor.App_blue_color),
                          backgroundColor: Colors.white, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded button
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                        ),
                        child: Text(buttonText),
                      ),
                    ],
                  ),
                ),
              ),
              // Right section (Image)
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.asset(
                    imageUrl, // Replace with your image URL
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: screenWidth *
                        0.35, // Adjust image width based on screen size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
