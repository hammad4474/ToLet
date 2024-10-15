import 'package:flutter/material.dart';
import 'package:tolet/screens/appbarScreens/home_appbar.dart';
import 'package:tolet/screens/popup_screen.dart';
import 'package:tolet/screens/tenant/SearchPropertyScreen.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';
import 'package:tolet/screens/tenant/property_decorofcard.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';

class HometenantScreen extends StatefulWidget {
  @override
  const HometenantScreen({super.key});

  @override
  _HometenantScreenState createState() => _HometenantScreenState();
}

class _HometenantScreenState extends State<HometenantScreen> {
  String _selectedLocation = 'Hyderabad';
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

  // Define your property data here
  final List<Map<String, dynamic>> data = [
    {
      "title": "Near your location",
      "item": "43 properties available",
      "properties": [
        {
          "title": "Small cottage with great view of Bagmati",
          "city": "Hyderabad",
          "price": "₹10,000",
          "isVerified": true,
          "rooms": "2 bedrooms",
          "area": "673 m²",
          "imageUrl": "assets/images/home2.png",
        },
        {
          "title": "Luxury Apartment",
          "city": "Hyderabad",
          "price": "₹12,000",
          "isVerified": false,
          "rooms": "3 bedrooms",
          "area": "800 m²",
          "imageUrl": "assets/images/home1.png",
        },
      ],
    },
    {
      "title": "Temporary Stay",
      "item": "43 properties available",
      "properties": [
        {
          "title": "Budget Room",
          "city": "Noida",
          "price": "₹6,000",
          "isVerified": true,
          "rooms": "1 bedroom",
          "area": "300 m²",
          "imageUrl": "assets/images/home0.png",
        },
        {
          "title": "Luxury Condo",
          "city": "Mumbai",
          "price": "₹20,000",
          "isVerified": true,
          "rooms": "4 bedrooms",
          "area": "1000 m²",
          "imageUrl": "assets/images/home0.png",
        },
      ],
    },
  ];

  // Function to handle tap on navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setSelectedCity(String city) {
    setState(() {
      _selectedLocation = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchBarTapped: () {
          // Navigate to SearchPropertyScreen when the search bar is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPropertyScreen()),
          );
        },
        onTuneIconPressed: () {
          // Navigate to SearchPropertyScreen when the search bar is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilterScreen()),
          );
        },
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Selector
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Your current locations',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (BuildContext context) => Center(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 450, maxHeight: 600),
                      child: CitySelectionDialog(
                        cities: cities,
                        onCitySelected: _setSelectedCity,
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
              padding: const EdgeInsets.only(left: 16.0, top: 19.0),
              child: Text(
                'Welcome to Tenant',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 50, // Height for the outer grey container
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      Colors.grey[200], // Background color for the entire row
                  borderRadius: BorderRadius.circular(
                      30), // Rounded corners for the entire container
                ),
                child: Row(
                  children: [
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
                            'Owner',
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
                              Color(0xFF4DB6F3),
                              Color(0xFF0288D1)
                            ], // Gradient for selected button
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Tenant',
                            style: TextStyle(
                              color: Colors
                                  .white, // Text color for highlighted button
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Access verified property listings. Connect with multiple property owners',
                  style: TextStyle(
                    color: Colors.grey, // Text color for unselected button
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Property ListView
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final section = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          section['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                section['item'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle "See more" action
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Horizontal ListView for properties
                        Container(
                          height:
                              189, // Adjust height for horizontal list items
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: section['properties'].length,
                            itemBuilder: (context, propIndex) {
                              final propertyData =
                                  section['properties'][propIndex];
                              final property = Property.fromMap(
                                  propertyData); // Convert Map to Property
                              return PropertyCard(property: property);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomtenantBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
