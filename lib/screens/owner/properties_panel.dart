// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';
import 'package:tolet/screens/tenant/listview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertiesPanel extends StatefulWidget {
  const PropertiesPanel({super.key});

  @override
  State<PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends State<PropertiesPanel> {
  bool isVerified = true;

  final User? user = FirebaseAuth.instance.currentUser;
  late Future<List<Map<String, dynamic>>> userProperties;

  @override
  void initState() {
    super.initState();
    userProperties = fetchUserProperties();
  }

  Future<List<Map<String, dynamic>>> fetchUserProperties() async {
    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('properties')
            .get();

        List<Map<String, dynamic>> properties = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        print('Fetched properties: $properties'); // Debugging line

        return properties;
      } catch (e) {
        print('Error fetching properties: $e');
        return [];
      }
    }
    print('No user is logged in.'); // Debugging line
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white, // Set AppBar background color
          iconTheme:
              IconThemeData(color: Colors.black), // Set icon color to black
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back),
              ),
              Text(
                'Properties',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: userProperties,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching properties.'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Map<String, dynamic>> properties = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "Property Panel" Text with styling
                            Text(
                              'Property Panel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28, // Larger font for more impact
                                color: Colors.black, // Stronger contrast
                                letterSpacing:
                                    1.5, // Adds spacing between letters for elegance
                              ),
                            ),

                            // Spacing between title and description
                            SizedBox(height: 8),

                            // "Just add the property..." Text with improved styling
                            Text(
                              'Easily list your property for a global audience!',
                              style: TextStyle(
                                fontSize:
                                    16, // Slightly larger for better readability
                                color: Colors
                                    .grey[600], // Softer grey for a modern look
                                height:
                                    1.5, // Line height for improved readability
                              ),
                            ),

                            // Optional: Add a subtle divider for a sleek separation
                            SizedBox(
                                height: 16), // Space before the next section
                            Divider(
                              thickness: 1.5,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Verified Properties',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '10 properties in india',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff7d7f88)),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return buildPropertyCard(context, property, true,
                                false); // Add context and onTip
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pending Verifications',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return buildPropertyCard(context, property, false,
                                false); // Add context and onTip
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
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: 0, onTap: (value) {}),
      ),
    );
  }
}

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property,
    bool isVerified, bool onTip) {
  double screenWidth = MediaQuery.of(context).size.width;

  double cardWidth = screenWidth > 450
      ? screenWidth * 0.9
      : screenWidth * 0.9; // 80% for larger screens, 90% for smaller
  double cardHeight = 250; // Fixed height for consistency
  double imageWidth = 108; // Fixed image width
  double iconSize = 24.0; // Standard icon size

  return Padding(
    padding: const EdgeInsets.all(8.0),
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
        height: 200,
        width: 400,
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
                    Icon(Icons.bed),
                    SizedBox(width: 5),
                    Text('${property['bhk']}'),
                    SizedBox(width: 10),
                    Icon(Icons.house),
                    SizedBox(width: 5),
                    Text('${property['area'] ?? 'Unknown Area'} m²'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('${property['price']}'),
                    Text(' / month'),
                  ],
                ),
                SizedBox(height: 20),
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
