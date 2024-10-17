// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolet/screens/appbarScreens/home_appbar.dart';
import 'package:tolet/screens/popup_screen.dart';
import 'package:tolet/screens/tenant/SearchPropertyScreen.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';
import 'package:tolet/screens/tenant/property_decorofcard.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';
import 'package:tolet/widgets/constcolor.dart';

class HometenantScreen extends StatefulWidget {
  @override
  const HometenantScreen({super.key});

  @override
  _HometenantScreenState createState() => _HometenantScreenState();
}

class _HometenantScreenState extends State<HometenantScreen> {
  String _selectedLocation = 'Hyderabad';
  late Future<List<Map<String, dynamic>>> userProperties;

  int _selectedIndex = 0;
  List<Property> _properties = [];
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
  void initState() {
    super.initState();
    userProperties = fetchAllProperties();
  }

  Future<List<Map<String, dynamic>>> fetchAllProperties() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(
              'propertiesAll') // Assuming properties are under 'propertiesAll'
          .get();

      List<Map<String, dynamic>> properties = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      print('Fetched properties count: ${properties.length}');

      setState(() {
        _properties = properties.map((data) => Property.fromMap(data)).toList();
      });

      return properties; // Return the list of properties
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchBarTapped: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPropertyScreen()),
          );
        },
        onTuneIconPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: FilterScreen(),
              ),
            ),
          );
        },
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    Icon(Icons.location_on, color: Color(constcolor.App_blue_color)),
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
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
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
                              Color(constcolor.App_lightblue_color),
                              Color(constcolor.App_blue_color)
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
              child: _properties.isNotEmpty
                  ? SingleChildScrollView(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: userProperties,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error fetching properties.'));
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            List<Map<String, dynamic>> properties =
                                snapshot.data!;

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      'Near your location',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '43 properties near you',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff747b7d)),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'see all',
                                              style:
                                                  TextStyle(color: Color(constcolor.App_blue_color)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: properties.length,
                                      itemBuilder: (context, index) {
                                        final property = properties[index];
                                        return buildPropertyCard(
                                            property, true);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      'Temporary stay',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '43 properties near you',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff747b7d)),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'see all',
                                              style:
                                                  TextStyle(color: Color(constcolor.App_blue_color)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: properties.length,
                                      itemBuilder: (context, index) {
                                        final property = properties[index];
                                        return buildPropertyCard(
                                            property, false);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(child: Text('No properties found.'));
                          }
                        },
                      ),
                    )
                  : Center(
                      child:
                          CircularProgressIndicator()), // Show loader while fetching
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

Widget buildPropertyCard(Map<String, dynamic> property, bool isVerified) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 3,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 200,
        width: 410,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            property['imageURL'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    child: Image.network(
                      property['imageURL'],
                      fit: BoxFit.cover,
                      height: 250,
                      width: 110,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    child: Image.asset(
                      'assets/icons/wifi.png',
                      height: 250,
                    ),
                  ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  property['propertyTitle'] ?? 'No Title',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(property['location'] ?? 'Unknown Location',
                    style: TextStyle(color: Color(0xff7d7f88), fontSize: 16)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.bed,
                      color: Color(0xff7d7f88),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${property['bhk']}',
                      style: TextStyle(color: Color(0xff7d7f88)),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.house,
                      color: Color(0xff7d7f88),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${property['area'] ?? 'Unknown Area'} m²',
                      style: TextStyle(color: Color(0xff7d7f88)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '${property['price']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      ' / month',
                      style: TextStyle(color: Color(0xff7d7f88)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  isVerified ? 'Verified' : 'Not Verified',
                  style: TextStyle(
                      color: isVerified ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(
                  isVerified ? Icons.verified_user : Icons.not_interested_sharp,
                  color: isVerified ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
