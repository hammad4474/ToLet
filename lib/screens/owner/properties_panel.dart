// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
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
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
              ),
              Text(
                'Properties',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
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
                        child: Text(
                          'Property Panel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Just add the property\nto list on worldwide market!',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff747b7d)),
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
                            return buildPropertyCard(property, true);
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
                            return buildPropertyCard(property, false);
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
            CustomtenantBottomNavBar(currentIndex: 0, onTap: (value) {}),
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
