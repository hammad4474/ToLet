// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';

class ListPropertyScreen extends StatefulWidget {
  const ListPropertyScreen({Key? key}) : super(key: key);

  @override
  _ListPropertyScreenState createState() => _ListPropertyScreenState();
}

class _ListPropertyScreenState extends State<ListPropertyScreen> {
  int _selectedIndex = 0;  // Keep track of the selected index

  // Function to handle tap on navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add logic here for navigation or any other action
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List new property'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List in the market where renters are waiting!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              // Property Title Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Property title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),  // Adjust the value for more or less curve
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Location (map placeholder)
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(child: Icon(Icons.map, size: 50, color: Colors.grey)),
              ),
              SizedBox(height: 20),
              // BHK Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(label: Text('1 BHK'), selected: false),
                  ChoiceChip(label: Text('2 BHK'), selected: false),
                  ChoiceChip(label: Text('3 BHK'), selected: true),
                  ChoiceChip(label: Text('4 BHK'), selected: false),
                ],
              ),
              SizedBox(height: 20),
              // Rent input
              TextField(
                decoration: InputDecoration(
                  labelText: '10,000/month',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Facilities Grid
              Text(
                'Facilities',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  facilityIcon(Icons.directions_car, 'Car Parking'),
                  facilityIcon(Icons.home, 'Furnished'),
                  facilityIcon(Icons.fitness_center, 'Gym & Fit'),
                  facilityIcon(Icons.restaurant_menu, 'Kitchen'),
                  facilityIcon(Icons.wifi, 'Wi-Fi'),
                  facilityIcon(Icons.pets, 'Pet Center'),
                  facilityIcon(Icons.directions_run, 'Sports CL'),
                  facilityIcon(Icons.local_laundry_service, 'Laundry'),
                ],
              ),
              SizedBox(height: 20),
              // Upload photos
              GestureDetector(
                onTap: () {
                  // Functionality for uploading pictures
                },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,// Align to the left
                        children: [
                          // "Photos" label above the camera icon
                          Text(
                            'Photos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded, color: Colors.grey, size: 30),
                              // "Upload Property Pictures" on the left
                              Text('Upload Property Pictures'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {
                      setState(() {
                        // Update the checkbox value
                      });
                    },
                  ),
                  Expanded(
                    child: Text('I agree to the terms and conditions'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Functionality for submitting the form
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF568203),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0), // Slightly square edges, adjust value as needed
                    ),
                  ),
                  child: Text('SUBMIT', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )
    );
  }

  Widget facilityIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

