
import 'package:flutter/material.dart';

class PropertyDetailScreen extends StatefulWidget {
  @override
  const PropertyDetailScreen({super.key});
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Details"),
        actions: [
          IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Carousel
            Container(
              height: 250,
              child: PageView(
                children: [
                  Image.asset('assets/property_image1.jpg', fit: BoxFit.cover),
                  Image.asset('assets/property_image2.jpg', fit: BoxFit.cover),
                  Image.asset('assets/property_image3.jpg', fit: BoxFit.cover),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Title and Details
                  Text(
                    'Small Cottage in Hyderabad view of bagmati',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('4.1 (66 reviews)'),
                      SizedBox(width: 16),
                      Text('2 room'),
                      SizedBox(width: 16),
                      Text('874 m²'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kapan, Jorpati',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Divider(),
                  // Owner Section
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/owner_image.jpg'),
                    ),
                    title: Text('Anil', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Property owner'),
                    trailing: IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        // Call functionality
                      },
                    ),
                  ),
                  Divider(),
                  // Tabs for Description, Gallery, Review
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Description'),
                            Tab(text: 'Gallery'),
                            Tab(text: 'Review'),
                          ],
                        ),
                        Container(
                          height: 100,
                          child: TabBarView(
                            children: [
                              Text('This is a small cottage with a beautiful view of Bagmati river...'),
                              Text('Gallery will be shown here'),
                              Text('Reviews will be shown here'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // Home Facilities
                  Text(
                    'Home facilities',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      facilityIcon(Icons.local_parking, 'Car Parking'),
                      facilityIcon(Icons.wifi, 'WiFi'),
                      facilityIcon(Icons.pool, 'Swimming Pool'),
                      facilityIcon(Icons.fitness_center, 'Gym & Fit'),
                      facilityIcon(Icons.restaurant, 'Restaurant'),
                      facilityIcon(Icons.local_laundry_service, 'Laundry'),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Navigate to see all facilities screen
                    },
                    child: Text(
                      'See all facilities',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Divider(),
                  // Price Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹10,000 / month',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('Payment estimation'),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Call functionality
                          },
                          icon: Icon(Icons.phone),
                          label: Text('Call'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget facilityIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(icon, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}