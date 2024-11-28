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
  List<QueryDocumentSnapshot> _filteredProperties = [];

  // This function will receive the filtered properties from the FilterScreen
  void _onFilterApplied(List<QueryDocumentSnapshot> filteredProperties) {
    setState(() {
      _filteredProperties = filteredProperties;
    });
  }

  void _resetFilter() {
    setState(() {
      _filteredProperties = [];
    });
  }

  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<QueryDocumentSnapshot> filteredProperties = []; // Holds filtered results

  // Filter parameters (can be extended for other filters)
  double minPrice = 0.0;
  double maxPrice = 10000.0;
  Map<String, bool> facilities = {
    'Wi-Fi': false,
    'Parking': false,
    'Swimming Pool': false,
  };

  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  // Reset all filters to default values
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

  // Function to apply filters
  // Modify this method to accept List<QueryDocumentSnapshot>
  void applyFilters(List<QueryDocumentSnapshot> newFilteredProperties) {
    setState(() {
      _filteredProperties =
          newFilteredProperties; // Set the filtered properties
    });
  }

  // Fetch properties with the applied filters from Firestore
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
                  'assets/icons/search-normal.png',
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
                'assets/icons/tune.png',
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

                    // Use _filteredProperties if it has any data
                    final propertiesToDisplay = _filteredProperties.isEmpty
                        ? propertyDocs
                        : _filteredProperties;

                    int matchCount = propertiesToDisplay.length;

                    if (propertiesToDisplay.isEmpty) {
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
                            itemCount: propertiesToDisplay.length,
                            itemBuilder: (context, index) {
                              final property = propertiesToDisplay[index];
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
              ownerId: '',
            ),
            transition: Transition.leftToRight,
          );
        },
        child: Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5.0),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.property['imageURLs'][0] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property['propertyTitle'] ?? 'Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: iconSize),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '₹ ${widget.property['price'] ?? 'Price'}',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            onTip ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 24.0,
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
    );
  }
}
