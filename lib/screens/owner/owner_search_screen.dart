import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/owner_property_detail.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';

class OwnerSearchScreen extends StatefulWidget {
  const OwnerSearchScreen({Key? key}) : super(key: key);

  @override
  _OwnerSearchScreenState createState() => _OwnerSearchScreenState();
}

class _OwnerSearchScreenState extends State<OwnerSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<QueryDocumentSnapshot> filteredProperties = [];
  List<QueryDocumentSnapshot> _filteredProperties = [];
  double minPrice = 0.0;
  double maxPrice = 10000.0;
  Map<String, bool> facilities = {
    'Wi-Fi': false,
    'Parking': false,
    'Swimming Pool': false,
  };

  void resetFilters() {
    setState(() {
      searchQuery = "";
      filteredProperties.clear(); // Clear any filters applied
      minPrice = 0.0;
      maxPrice = 10000.0;
      facilities = {
        'Wi-Fi': false,
        'Parking': false,
        'Swimming Pool': false,
      };
    });

    // Now fetch all properties
    fetchFilteredProperties();
  }

  void applyFilters(List<QueryDocumentSnapshot> newFilteredProperties) {
    setState(() {
      _filteredProperties =
          newFilteredProperties; // Set the filtered properties
    });
  }

  fetchFilteredProperties() async {
    final query = FirebaseFirestore.instance.collection('propertiesAll');

    // Apply filters if necessary
    QuerySnapshot snapshot;
    if (_filteredProperties.isEmpty) {
      snapshot = await query.get(); // No filters applied, fetch all properties
    } else {
      snapshot = await query
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .get();
    }

    List<QueryDocumentSnapshot> fetchedProperties = snapshot.docs.where((doc) {
      double propertyPrice = double.tryParse(doc['price']) ?? 0.0;
      List<String> propertyFacilities = List<String>.from(doc['facilities']);
      bool matchesFacilities = facilities.keys.every((facility) {
        if (facilities[facility]!) {
          return propertyFacilities.contains(facility);
        }
        return true;
      });

      return propertyPrice >= minPrice &&
          propertyPrice <= maxPrice &&
          matchesFacilities;
    }).toList();

    setState(() {
      _filteredProperties = fetchedProperties; // Display the fetched properties
    });
  }

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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: FilterScreen(
                        onFilterApplied:
                            applyFilters, // Pass filter results back to applyFilters
                        onReset: resetFilters, // Reset filters callback
                      ),
                    );
                  },
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
    double cardWidth = screenWidth * 1.0;
    double imageWidth = screenWidth * 0.3;
    double iconSize = 22.0;

    // bool isVerified = widget.property['isVerified'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => OwnerPropertyDetailScreen(
              title: widget.property['propertyTitle'] ?? 'No Title',
              price: widget.property['price'] ?? 'Price',
              location: widget.property['location'] ?? 'Location',
              area: widget.property['area'] ?? 'Area',
              bhk: widget.property['bhk']?.toString() ?? 'BHK',
              imageURLs: widget.property['imageURLs'] != null &&
                      widget.property['imageURLs'].isNotEmpty
                  ? List<String>.from(widget.property['imageURLs'])
                  : [],
              owner: widget.property['owner'] ?? 'Unknown Owner',
              propertyId: widget.property.id, // Correctly pass the property ID
              facilities: widget.property['facilities'] != null
                  ? List<String>.from(widget.property['facilities'])
                  : [],
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
                            // if (isVerified)
                            //   Icon(
                            //     Icons.verified,
                            //     color: Colors.blue,
                            //     size: iconSize,
                            //   ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.property['propertyTitle'] ?? 'No Title',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Location
                        Text(
                          'Location',
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
                              widget.property['bhk'] ?? '0',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.square_foot,
                                color: Color(0xff7d7f88), size: iconSize),
                            SizedBox(width: 4),
                            Text(
                              'Area',
                              style: TextStyle(color: Color(0xff7d7f88)),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Price and Favorite Icon Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.property['price'] ?? 'Price'}/ month',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  onTip = !onTip;
                                });
                              },
                              child: Icon(
                                onTip ? Icons.favorite : Icons.favorite_border,
                                color: onTip ? Colors.red : Colors.grey,
                                size: iconSize,
                              ),
                            ),
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
