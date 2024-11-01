// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/ownerdashboard.dart';
import 'package:tolet/screens/owner/owner_property_detail.dart';
import 'package:tolet/screens/owner/update_property_screen.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
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

  String username = '';

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

        List<Map<String, dynamic>> properties = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;

          return data;
        }).toList();

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
                        height: 189,
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
                        height: 189,
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
        // bottomNavigationBar:
        //     CustomBottomNavigationBar(currentIndex: 0, onTap: (value) {}),
      ),
    );
  }
}

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property,
    bool isVerified, bool onTip) {
  double screenWidth = MediaQuery.of(context).size.width;

  double cardWidth = screenWidth < 450 ? screenWidth * 0.9 : screenWidth * 0.9;
  double cardHeight = 180;
  double imageWidth = screenWidth * 0.3;
  double iconSize = 22.0; // Standard icon size

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onLongPress: () {
        print('long pressed');
        _showOptionsDialog(context, property);
      },
      onTap: () {
        // Passing all relevant property details to the next screen
        Get.to(
          () => OwnerPropertyDetailScreen(
            title: property['propertyTitle'] ?? 'No Title',
            price: property['price'] ?? 'Price',
            location: property['location'] ?? 'Location',
            area: property['area'] ?? 'Area',
            bhk: property['bhk']?.toString() ?? 'BHK',
            imageURLs: property['imageURLs'] != null &&
                    property['imageURLs'].isNotEmpty
                ? List<String>.from(property['imageURLs'])
                : [], // Pass an empty list if no images are found
            // Only passing the first image URL
            //  isVerified: isVerified,
            owner: property['firstname'] ?? 'Owner',
            propertyId: property['id'] ?? '',
            facilities: property['facilities'] != null
                ? List<String>.from(property['facilities'])
                : [], // Ensure facilities are passed
          ),
          transition: Transition.fadeIn,
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                      Flexible(
                        child: Row(
                          children: [
                            Icon(Icons.bed,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 2),
                            Text(
                              '${property['bhk']}',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.square_foot,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 2),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '${property['area'] ?? 'Area'} m²',
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
                      ), // Spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // child: Card(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(15),
      //   ),
      //   elevation: 3,
      //   shadowColor: Colors.black,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(15),
      //     ),
      //     height: 200,
      //     width: 400,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         property['imageURLs'] != null && property['imageURLs'].isNotEmpty
      //             ? ClipRRect(
      //                 borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(15),
      //                     bottomLeft: Radius.circular(15)),
      //                 child: Image.network(
      //                   property['imageURLs'][0],
      //                   fit: BoxFit.cover,
      //                   height: 250,
      //                   width: 110,
      //                 ),
      //               )
      //             : ClipRRect(
      //                 borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(15),
      //                     bottomLeft: Radius.circular(15)),
      //                 child: Image.asset(
      //                   'assets/icons/wifi.png',
      //                   height: 250,
      //                 ),
      //               ),
      //         SizedBox(width: 20),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             SizedBox(height: 20),
      //             Text(
      //               property['propertyTitle'] ?? 'No Title',
      //               style: TextStyle(fontSize: 18),
      //             ),
      //             SizedBox(height: 10),
      //             Text(property['location'] ?? 'Unknown Location',
      //                 style: TextStyle(color: Color(0xff7d7f88), fontSize: 16)),
      //             SizedBox(height: 10),
      //             Row(
      //               children: [
      //                 Icon(Icons.bed),
      //                 SizedBox(width: 5),
      //                 Text('${property['bhk']}'),
      //                 SizedBox(width: 10),
      //                 Icon(Icons.house),
      //                 SizedBox(width: 5),
      //                 Text('${property['area'] ?? 'Unknown Area'} m²'),
      //               ],
      //             ),
      //             SizedBox(height: 20),
      //             Row(
      //               children: [
      //                 Text('${property['price']}'),
      //                 Text(' / month'),
      //               ],
      //             ),
      //             SizedBox(height: 20),
      //             Text(
      //               isVerified ? 'Verified' : 'Not Verified',
      //               style: TextStyle(
      //                   color: isVerified ? Colors.green : Colors.red,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 16),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //           ],
      //         ),
      //         SizedBox(width: 20),
      //         Column(
      //           children: [
      //             SizedBox(height: 20),
      //             Icon(
      //               isVerified
      //                   ? Icons.verified_user
      //                   : Icons.not_interested_sharp,
      //               color: isVerified ? Colors.green : Colors.red,
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    ),
  );
}

void _showOptionsDialog(BuildContext context, Map<String, dynamic> property) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose an option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: Text('Update'),
              onTap: () {
                Get.to(() => UpdatePropertyScreen(property: property));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: Text('Delete'),
              onTap: () async {
                // Handle delete property action
                final confirmation =
                    await _showDeleteConfirmationDialog(context);
                if (confirmation == true) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('properties')
                      .doc(property['id'])
                      .delete();
                  Navigator.pop(context); // Close the bottom sheet
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // No
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Yes
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
