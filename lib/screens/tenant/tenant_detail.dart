import 'package:flutter/material.dart';
import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/tenant/bottom_navbar.dart';
import 'package:tolet/widgets/constcolor.dart';


class TenantDetailsScreen extends StatefulWidget {
  @override
  State<TenantDetailsScreen> createState() => _TenantDetailsScreenState();
}

class _TenantDetailsScreenState extends State<TenantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text(
          'Rentaxo',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/dp.png'), // Correct path
                  ),

                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elon Musk',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'TENANT PRO',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the box
                      shape: BoxShape.circle, // Circular box shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2, // How far the shadow spreads
                          blurRadius: 5, // How blurry the shadow is
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.call, color: Colors.grey), // Grey call icon
                      onPressed: () {
                        // Handle call action
                      },
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),
        
              // Requirements Section
              Text(
                'Requirements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Air conditioner'),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Align WiFi to the end
                    children: [
                      Container(
                        width: 30,  // Set the width of the square
                        height: 30, // Set the height of the square
                        decoration: BoxDecoration(
                          color: Colors.grey, // Grey background for the box
                          borderRadius: BorderRadius.circular(8.0), // Slight rounding for square corners
                        ),
                        child: Center(
                          child: Icon(Icons.wifi, color: Colors.white), // White WiFi icon
                        ),
                      ),
                      SizedBox(width: 4), // Reduce space between the icon and the text
                      Text('Free WiFi'),
                    ],
                  ),
                ],
              ),


              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Free parking'),
                ],
              ),
              SizedBox(height: 20),
        
              // Map Section (Use a placeholder image for map)
              Container(
                height: 200,
                width: double.infinity,
                child: Image.asset('assets/images/Location.png',fit: BoxFit.cover,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                  // Background color for placeholder
                ),
              ),
              SizedBox(height: 20),
        
              // Description Section
              Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'I\'m looking for a rental room in Hyderabad. The room should be single, furnished, and include basic amenities like Internet, Air Conditioning, ideally, and access to the kitchen. My budget is 20k. I need it! Proximity to public transport.',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              SizedBox(height: 20),
        
              // Contact Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    gradient: LinearGradient(
                      colors: [Color(constcolor.App_lightblue_color), Color(constcolor.App_blue_color)], // Light blue to dark blue gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make button background transparent
                      shadowColor: Colors.transparent, // Remove shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle contact action
                    },
                    child: Text(
                      'Contact',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomtenantBottomNavBar(
        currentIndex: 1, // Example currentIndex to highlight 'Requests'
        onTap: (index) {
          // Handle bottom navigation action
        },
      ),
    );
  }
}
