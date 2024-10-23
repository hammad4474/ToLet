// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/chat_screen.dart';
import 'package:tolet/screens/tenant/description.dart';
import 'package:tolet/screens/tenant/galler_pd.dart';
import 'package:tolet/screens/tenant/reveiw_pd.dart';
import 'package:tolet/screens/tenant/tenant_chatscreen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String title;
  final String location;
  final String price;
  final String area;
  final String bhk;
  final String imageURL;
  final bool isVerified;
  final String owner;
  final String propertyId;

  PropertyDetailsScreen({
    required this.title,
    required this.location,
    required this.price,
    required this.area,
    required this.bhk,
    required this.imageURL,
    required this.isVerified,
    required this.owner,
    required this.propertyId, // Ensure this matches
    Key? key,
  }) : super(key: key);
  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int selectedTabIndex = 0;
  String ownerName = "";
  List<String> facilities = [];
  List<String> galleryImages = [];
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorited();
    fetchPropertyDetails();
  }

  Future<void> checkIfFavorited() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final tenantFavorites = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.propertyId)
          .get();

      setState(() {
        isFavorited = tenantFavorites.exists;
      });
    }
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.propertyId);

      if (isFavorited) {
        // If it's already favorited, remove from favorites
        await favoritesRef.delete();
      } else {
        // If it's not favorited, add to favorites
        await favoritesRef.set({
          'propertyId': widget.propertyId,
          'title': widget.title,
          'location': widget.location,
          'price': widget.price,
          'bhk': widget.bhk,
          'imageURLs': widget.imageURL,
        });
      }

      setState(() {
        isFavorited = !isFavorited;
      });
    }
  }

  Future<void> fetchPropertyDetails() async {
    try {
      DocumentSnapshot propertySnapshot = await FirebaseFirestore.instance
          .collection('propertiesAll')
          .doc(widget.propertyId)
          .get();

      if (propertySnapshot.exists) {
        print('Fetched Data: ${propertySnapshot.data()}');

        var facilitiesData = propertySnapshot.get('facilities');
        if (facilitiesData is List) {
          setState(() {
            facilities = List<String>.from(facilitiesData);
          });
        } else {
          print('Facilities data is not a list: $facilitiesData');
        }

        var galleryData = propertySnapshot.get('imageURLs');
        if (galleryData is String) {
          setState(() {
            galleryImages = [galleryData];
          });
        } else if (galleryData is List) {
          setState(() {
            galleryImages = List<String>.from(galleryData);
          });
        } else {
          print('Gallery images data is not a string or list: $galleryData');
        }
      } else {
        print('Property not found');
      }
    } catch (e) {
      print('Error fetching property details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          width: 20, // Width for the back button
          height: 20, // Height for the back button
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 18),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Action for share icon tap
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/share.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView(
                        children: [
                          Image.network(widget.imageURL, fit: BoxFit.cover),
                          Image.network('https://via.placeholder.com/400',
                              fit: BoxFit.cover),
                          Image.network('https://via.placeholder.com/400',
                              fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xff192747),
                                Color(0xFF1C66AD),
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Action for video button
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: Center(
                                child: Text(
                                  'Watch Intro Video',
                                  style: TextStyle(
                                    color: Color(0xff192747),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorited ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              toggleFavorite();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              SizedBox(width: 5),
                              Text('4.1 (66 reviews)'),
                            ],
                          ),
                          SizedBox(width: 100),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/bed.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text('${widget.bhk}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(widget.location),
                            ],
                          ),
                          SizedBox(width: 80),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/home.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(widget.area, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/delhi.png'),
                            radius: 24,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.owner.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text('Property owner'),
                            ],
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            width: 40,
                            height: 40,
                            child: IconButton(
                              icon: Icon(Icons.phone, color: Colors.grey),
                              onPressed: () {
                                // Phone call functionality here
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildTab('Description', 0),
                          buildTab('Gallery', 1),
                          buildTab('Review', 2),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (selectedTabIndex == 0) buildDescriptionContent(),
                      if (selectedTabIndex == 1) buildGalleryContent(),
                      if (selectedTabIndex == 2) buildReviewContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${widget.price} / month',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Payment estimation',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Get.to(() => tenantChatScreen(), transition: Transition.fade);
                },
                child: Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff192747),
                          Color(0xff192750),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Contact',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    // ElevatedButton.icon(
                    //   onPressed: () {Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => ChatScreen()),
                    //   );
                    //     // Call button functionality here
                    //   },
                    //   label: Text(
                    //     'Contact',
                    //     style: TextStyle(color: Colors.white),
                    //   ),

                    // ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selectedTabIndex == index
                    ? Color(0xff192747)
                    : Colors.black),
          ),
          if (selectedTabIndex == index)
            Container(height: 2, width: 60, color: Color(0xff192747))
        ],
      ),
    );
  }

// for facilities
  Widget buildDescriptionContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Home Facilities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Text(
              //   'See all facilities',
              //   style: TextStyle(color: Color(0xff192747), fontSize: 16),
              // ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (facilities.contains('Car Parking'))
                    buildFacilityIcon('assets/icons/CAR.png', 'Car Parking'),
                  if (facilities.contains('Furnished'))
                    buildFacilityIcon(
                        'assets/icons/Vector (3).png', 'Furnished'),
                  if (facilities.contains('Gym Fit'))
                    buildFacilityIcon('assets/icons/GYM.png', 'Gym Fit'),
                  if (facilities.contains('Kitchen'))
                    buildFacilityIcon('assets/icons/FOOD.png', 'Kitchen'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (facilities.contains('WI-fi'))
                    buildFacilityIcon('assets/icons/WIFI.png', 'Wi-Fi'),
                  if (facilities.contains('Pet center'))
                    buildFacilityIcon('assets/icons/PET.png', 'Pet Center'),
                  if (facilities.contains('Sports'))
                    buildFacilityIcon('assets/icons/RUN.png', 'Sports Club'),
                  if (facilities.contains('Laundry'))
                    buildFacilityIcon('assets/icons/LAUNDRY.png', 'Laundry'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGalleryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Gallery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            // Text(
            //   'See all',
            //   style: TextStyle(color: Color(0xff192747), fontSize: 16),
            // ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: galleryImages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    galleryImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
