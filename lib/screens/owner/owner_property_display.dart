import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      // Fetch all properties from the 'propertiesAll' collection
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
    return Scaffold(
      appBar: AppBar(
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

                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 properties per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            0.75, // Adjust the ratio to fit the cards
                      ),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return buildPropertyCard(context, property);
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

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property) {
  double cardHeight = 250;
  double imageWidth = 108;
  double iconSize = 24.0;

  return GestureDetector(
    onTap: () {
      // Get.to(() => PropertyDetailsScreen(
      //       title: property['propertyTitle'] ?? 'No Title',
      //       location: property['location'] ?? 'Unknown Location',
      //       price: property['price'] ?? 'Unknown Price',
      //       area: property['area'] ?? 'Unknown Area',
      //       bhk: property['bhk'] ?? 'Unknown BHK',
      //       imageURL: property['imageURL'] ?? 'assets/icons/wifi.png',
      //       isVerified: true, // Assuming properties are verified
      //       owner: property['owner'],
      //       propertyId: property['id'] ?? 'Unknown id',
      //     ));
    },
    child: Card(
      elevation: 3,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: property['imageURL'] != null
                  ? Image.network(
                      property['imageURL'],
                      fit: BoxFit.fill,
                      height: 120,
                      width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['propertyTitle'] ?? 'No Title',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    property['location'] ?? 'Unknown Location',
                    style: TextStyle(color: Color(0xff7d7f88), fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.bed, color: Color(0xff7d7f88), size: iconSize),
                      SizedBox(width: 5),
                      Text(
                        '${property['bhk']}',
                        style: TextStyle(color: Color(0xff7d7f88)),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.house,
                          color: Color(0xff7d7f88), size: iconSize),
                      SizedBox(width: 5),
                      Text(
                        '${property['area']} sq.ft.',
                        style: TextStyle(color: Color(0xff7d7f88)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\INR${property['price']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
