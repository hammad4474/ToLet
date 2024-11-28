// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/appbarScreens/home_appbar.dart';
import 'package:tolet/screens/popup_screen.dart';
import 'package:tolet/screens/tenant/SearchPropertyScreen.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';
import 'package:tolet/screens/tenant/property_decorofcard.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';
import 'package:tolet/screens/tenant/see_all_properties.dart';
import 'package:tolet/widgets/constcolor.dart';

class HometenantScreen extends StatefulWidget {
  const HometenantScreen({super.key});

  @override
  _HometenantScreenState createState() => _HometenantScreenState();
}

class _HometenantScreenState extends State<HometenantScreen> {
  String _selectedLocation = 'Hyderabad';
  late Future<List<Map<String, dynamic>>> userProperties;
  bool onTip = false;
  //int _selectedIndex = 0;
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

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

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
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('propertiesAll').get();

      List<Map<String, dynamic>> properties = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        return data;
      }).toList();

      print('Fetched properties count: ${properties.length}');

      setState(() {
        _properties = properties.map((data) => Property.fromMap(data)).toList();
      });

      return properties;
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
          Get.to(() => SearchPropertyScreen(), transition: Transition.fade);
        },
        onTuneIconPressed: () {
          //  Get.to(() => FilterScreen(onFilterApplied: ,), transition: Transition.zoom);
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
                    Icon(Icons.location_on,
                        color: Color(constcolor.App_blue_color)),
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
              padding: const EdgeInsets.all(12.0),
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
                    // Expanded(
                    //   child: Container(
                    //     // Slightly smaller height for the inactive button
                    //     margin: const EdgeInsets.all(
                    //         7.5), // Center the smaller button vertically
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(30),
                    //       color: Colors
                    //           .transparent, // Background color for unselected button
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         'Owner',
                    //         style: TextStyle(
                    //           color: Colors
                    //               .grey, // Text color for unselected button
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                              Color(
                                  0xff192760), // Correct way to create a Color
                              Color(
                                  0xff192747), // Use the actual color value for App_blue_color
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
                                            onPressed: () {
                                              Get.to(() => SeeAllProperties(),
                                                  transition:
                                                      Transition.leftToRight);
                                            },
                                            child: Text(
                                              'see all',
                                              style: TextStyle(
                                                  color: Color(constcolor
                                                      .App_blue_color)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 189,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: properties.length,
                                      itemBuilder: (context, index) {
                                        final property = properties[index];
                                        return buildPropertyCard(
                                            context, property, true, false);
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
                                            onPressed: () {
                                              Get.to(() => SeeAllProperties(),
                                                  transition:
                                                      Transition.fadeIn);
                                            },
                                            child: Text(
                                              'see all',
                                              style: TextStyle(
                                                  color: Color(constcolor
                                                      .App_blue_color)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 189,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: properties.length,
                                      itemBuilder: (context, index) {
                                        final property = properties[index];
                                        return buildPropertyCard(
                                            context, property, false, true);
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
      // bottomNavigationBar: CustomtenantBottomNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property,
    bool isVerified, bool onTip) {
  double screenWidth = MediaQuery.of(context).size.width;

  double cardWidth = screenWidth < 450 ? screenWidth * 0.9 : screenWidth * 0.9;
  double cardHeight = 180;
  double imageWidth = screenWidth * 0.3;
  double iconSize = 22.0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: GestureDetector(
      onTap: () {
        Get.to(
          () => PropertyDetailsScreen(
            title: property['propertyTitle'] ?? 'No Title',
            location: property['location'] ?? 'Location',
            price: property['price'] ?? 'Price',
            area: property['area'] ?? 'Area',
            bhk: property['bhk'] ?? 'BHK',
            imageURL: property['imageURLs'][0] ?? 'assets/icons/wifi.png',
            isVerified: isVerified,
            owner: property['owner'] ?? '',
            propertyId: property['id'] ?? 'id',
            ownerId: property['ownerId'] ?? '',
          ),
          transition: Transition.fade,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: cardHeight,
          width: cardWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: property['imageURLs'] != null
                    ? Image.network(
                        property['imageURLs'][0],
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Image not available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                        height: cardHeight,
                        width: imageWidth,
                      )
                    : Image.asset(
                        'assets/icons/wifi.png',
                        fit: BoxFit.cover,
                        height: cardHeight,
                        width: imageWidth,
                      ),
              ),
              // Property details
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              property['propertyTitle'] ?? 'No Title',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            isVerified ? Icons.verified : Icons.not_interested,
                            color: isVerified ? Colors.green : Colors.red,
                            size: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Location
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          property['location'] ?? 'Location',
                          style:
                              TextStyle(color: Color(0xff7d7f88), fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 3),
                      // Icons and details row
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.bed,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 2),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '${property['bhk']}',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.square_foot,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 2),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '${property['area'] ?? 'Area'}',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          '${property['price']} / month',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),

                      // Price and verification

                      Spacer(),
                      Text(
                        isVerified ? 'Verified' : 'Not Verified',
                        style: TextStyle(
                          color: isVerified ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              'Property posted by ${property['owner']}',
                              softWrap: true,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     // Handle the tap event, e.g., toggle the favorite status
                          //     onTip = !onTip; // Toggle the value of onTip
                          //   },
                          //   child: Icon(
                          //     onTip ? Icons.favorite_border : Icons.favorite, // Show appropriate icon
                          //     color: onTip ? Colors.grey : Colors.red, // Change color based on status
                          //     size: iconSize,
                          //   ),
                          // ),
                        ],
                      ), // Spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
