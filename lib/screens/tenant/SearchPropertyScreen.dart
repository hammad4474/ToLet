import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';

class SearchPropertyScreen extends StatefulWidget {
  const SearchPropertyScreen({Key? key}) : super(key: key);

  @override
  _SearchPropertyScreenState createState() => _SearchPropertyScreenState();
}

class _SearchPropertyScreenState extends State<SearchPropertyScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  'assets/icons/search-normal.png', // Replace with your actual asset path
                  width: 24,
                  height: 24,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim();
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search for property',
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Image.asset(
                'assets/icons/tune.png', // Replace with your actual custom icon asset
                height: 40,
                width: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/static_map.png',
            fit: BoxFit.fill,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: searchQuery.isEmpty
                      ? FirebaseFirestore.instance
                          .collection('propertiesAll')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('propertiesAll')
                          .where('propertyTitle',
                              isGreaterThanOrEqualTo: searchQuery)
                          .where('propertyTitle',
                              isLessThanOrEqualTo: searchQuery + '\uf8ff')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final propertyDocs = snapshot.data!.docs;
                    int matchCount = propertyDocs.length;

                    if (propertyDocs.isEmpty) {
                      return Center(
                        child: Text('No properties found for "$searchQuery"'),
                      );
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text('Showing $matchCount results'),
                              Spacer(),
                              IconButton(
                                icon:
                                    const Icon(Icons.sort, color: Colors.black),
                                onPressed: () {},
                              ),
                              Text('Sort'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: propertyDocs.length,
                            itemBuilder: (context, index) {
                              final property = propertyDocs[index];
                              return SearchPropertyCard(property: property);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SearchPropertyCard extends StatefulWidget {
  final QueryDocumentSnapshot property;

  const SearchPropertyCard({Key? key, required this.property})
      : super(key: key);

  @override
  _SearchPropertyCardState createState() => _SearchPropertyCardState();
}

class _SearchPropertyCardState extends State<SearchPropertyCard> {
  bool onTip = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cardHeight = 180;
    double cardWidth = screenWidth * 1.0; // Adjust for responsiveness
    double imageWidth = screenWidth * 0.3; // Adjust based on screen width
    double iconSize = 22.0;
    //bool isVerified = widget.property.exists && widget.property['isVerified'] != null ? widget.property['isVerified'] : false;

    // Fetch dynamic verification status

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => PropertyDetailsScreen(
              propertyId: widget.property.id,
              title: widget.property['propertyTitle'] ?? 'Title',
              location: 'Location',
              price: widget.property['price'] ?? 'Price',
              imageURL: widget.property['imageURLs'][0] ?? '',
              area: 'Area',
              bhk: widget.property['bhk'] ?? 'Rooms',
              isVerified: false,
              owner: widget.property['owner'] ?? 'Owner',
            ),
            transition: Transition.leftToRightWithFade,
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
              children: [
                // Property Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: widget.property['imageURLs'] != null
                      ? Image.network(
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
                          widget.property['imageURLs'][0],
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
                // Property Details
                SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Verification Status
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/rating.png',
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(width: 4),
                            // Text(
                            //   '${property['rating'] ?? '0.0'}',
                            //   style: const TextStyle(color: Colors.grey),
                            // ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.property['propertyTitle'] ?? 'No Title',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        // Location
                        Text(
                          'City',
                          style:
                              TextStyle(color: Color(0xff7d7f88), fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        // Icons and Details Row
                        Row(
                          children: [
                            Icon(Icons.bed,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 4),
                            Text(
                              '${widget.property['bhk'] ?? '0'}',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.square_foot,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 4),
                            Text(
                              '${'28 m²'}',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                          ],
                        ),

                        // Price and Verification Text
                        // Owner and Favorite Icon Row
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.property['price'] + '/ month' ??
                                  'Price' + '/ month',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       onTip = !onTip; // Toggle the value of onTip
                            //     });
                            //   },
                            //   child: Icon(
                            //     onTip
                            //         ? Icons.favorite
                            //         : Icons
                            //             .favorite_border, // Show appropriate icon
                            //     color: onTip
                            //         ? Colors.red
                            //         : Colors
                            //             .grey, // Change color based on status
                            //     size: iconSize,
                            //   ),
                            // ),
                          ],
                        ),
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
}

    // return GestureDetector(
    //   onTap: () {
    //     Get.to(
    //         () => PropertyDetailsScreen(
    //               propertyId: property.id,
    //               title: property['propertyTitle'] ?? 'Unknown Title',
    //               location: 'Unkown Location',
    //               price: property['price'] ?? 'Unknown Price',
    //               imageURL: property['imageURL'] ?? '',
    //               area: 'Unknown Area',
    //               bhk: property['bhk'] ?? 'Unknown Rooms',
    //               isVerified: false,
    //               owner: property['owner'] ?? 'Unknown Owner',
    //             ),
    //         transition: Transition.leftToRightWithFade);
    //   },
    //   child: Container(
    //     margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(16),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey.withOpacity(0.3),
    //           spreadRadius: 2,
    //           blurRadius: 5,
    //         ),
    //       ],
    //     ),
    //     child: Row(
    //       children: [
    //         // Left Section: Image
    //         Container(
    //           width: screenWidth * 0.3,
    //           height: 189,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(8),
    //                 topRight: Radius.zero,
    //                 bottomLeft: Radius.circular(8),
    //                 bottomRight: Radius.zero),
    //             image: DecorationImage(
    //               image: NetworkImage(property['imageURL'] ?? ''),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 24),
    //         // Right Section: Details
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               // Rating
    //               Row(
    //                 children: [
    //                   Image.asset(
    //                     'assets/icons/rating.png',
    //                     height: 16,
    //                     width: 16,
    //                   ),
    //                   const SizedBox(width: 4),
    //                   // Text(
    //                   //   '${property['rating'] ?? '0.0'}',
    //                   //   style: const TextStyle(color: Colors.grey),
    //                   // ),
    //                 ],
    //               ),
    //               const SizedBox(height: 10),
    //               // Property Title
    //               Text(
    //                 property['propertyTitle'] ?? 'Unknown Title',
    //                 style: const TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black87,
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               // City
    //               Text(
    //                 'Unknown City',
    //                 style: const TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               // Property Details
    //               Row(
    //                 children: [
    //                   Image.asset(
    //                     'assets/icons/ic_bed.png',
    //                     height: 16,
    //                     width: 16,
    //                   ),
    //                   const SizedBox(width: 4),
    //                   Text(
    //                     '${property['bhk'] ?? '0'}',
    //                     style: const TextStyle(color: Colors.grey),
    //                   ),
    //                   const SizedBox(width: 8),
    //                   Image.asset(
    //                     'assets/icons/ic_area.png',
    //                     height: 16,
    //                     width: 16,
    //                   ),
    //                   const SizedBox(width: 4),
    //                   Text(
    //                     '${'28 m²'}',
    //                     style: const TextStyle(color: Colors.grey),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 8),
    //               // Price
    //               Row(
    //                 children: [
    //                   Text(
    //                     property['price'] ?? 'Unknown Price',
    //                     style: const TextStyle(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black87,
    //                     ),
    //                   ),
    //                   const Spacer(),
    //                   Image.asset(
    //                     'assets/icons/verified.png',
    //                     height: 20,
    //                     width: 20,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

