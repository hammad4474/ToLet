import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/fetch_all_properties.dart';
import 'package:tolet/screens/owner/owner_property_detail.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';

class HomeOwnerScreen extends StatefulWidget {
  const HomeOwnerScreen({super.key});

  @override
  _HomeOwnerScreenState createState() => _HomeOwnerScreenState();
}

class _HomeOwnerScreenState extends State<HomeOwnerScreen> {
  late Future<List<Map<String, dynamic>>> allProperties;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    allProperties = fetchAllProperties();
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

      return properties;
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Properties',
          style: TextStyle(color: Color(0xff1a2847)),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 19.0),
              child: Text(
                'Available Properties',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: allProperties,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching properties.'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Map<String, dynamic>> properties = snapshot.data!;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = screenWidth < 600 ? 2 : 3;
                        double childAspectRatio =
                            screenWidth < 600 ? 0.75 : 0.8;

                        return GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return buildPropertyCard(
                                context, property, screenWidth);
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No properties found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildPropertyCard(
    BuildContext context, Map<String, dynamic> property, double screenWidth) {
  double iconSize = 24.0;
  double fontSizeTitle = screenWidth < 600 ? 14.0 : 18.0;
  double fontSizeSubtitle = screenWidth < 600 ? 12.0 : 16.0;

  return GestureDetector(
    onTap: () {
      Get.to(
        () => FetchAllProperties(
          title: property['propertyTitle'] ?? 'No Title',
          location: property['location'] ?? 'Location',
          price: property['price'] ?? 'Price',
          area: property['area'] ?? 'Area',
          bhk: property['bhk'] ?? 'BHK',
          imageURLs: (property['imageURLs'] != null &&
                  property['imageURLs'].isNotEmpty)
              ? (property['imageURLs'] as List<dynamic>).cast<String>()
              : [],
          isVerified: true,
          owner: property['owner'] ?? 'Owner',
          propertyId: property['id'] ?? 'Unknown id',
          facilities: property['facilities'] != null
              ? (property['facilities'] as List<dynamic>).cast<String>()
              : [],
        ),
        transition: Transition.fadeIn,
      );
    },
    child: Card(
      elevation: 3,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: property['imageURLs'] != null &&
                      property['imageURLs'].isNotEmpty
                  ? Image.network(
                      property['imageURLs'][0],
                      fit: BoxFit.fill,
                      height: 110,
                      width: double.infinity,
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
                    )
                  : Image.asset(
                      'assets/icons/wifi.png',
                      height: 120,
                      width: double.infinity,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['propertyTitle'] ?? 'No Title',
                    style: TextStyle(fontSize: fontSizeTitle),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    property['location'] ?? 'Unknown Location',
                    style: TextStyle(
                      color: Color(0xff7d7f88),
                      fontSize: fontSizeSubtitle,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bed, color: Color(0xff7d7f88), size: iconSize),
                      SizedBox(width: 5),
                      Text(
                        '${property['bhk']} BHK',
                        style: TextStyle(color: Color(0xff7d7f88)),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.house,
                          color: Color(0xff7d7f88), size: iconSize),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          '${property['area']} sq.ft.',
                          style: TextStyle(color: Color(0xff7d7f88)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\INR${property['price']}',
                    style: TextStyle(
                        fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
