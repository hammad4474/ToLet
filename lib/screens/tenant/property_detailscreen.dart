import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/description.dart';
import 'package:tolet/screens/tenant/galler_pd.dart';
import 'package:tolet/screens/tenant/reveiw_pd.dart';

class PropertyDetailsScreen extends StatefulWidget {
  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int selectedTabIndex = 0;

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
            icon: Icon(Icons.arrow_back,
                color: Colors.white, size: 18), // Black back icon
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
              width: 40, // Match the width of the leading icon
              height: 40, // Match the height of the leading icon
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/share.png',
                  width: 24, // Size of the share icon
                  height: 24, // Size of the share icon
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
          // Padding to prevent overlap with bottom section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView(
                      children: [
                        Image.asset('assets/images/pd.png', fit: BoxFit.cover),
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
                    // Cylindrical Video Button
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // 90% of the screen width for padding on the sides
                        padding: EdgeInsets.all(
                            3), // Padding for the bold gradient border
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              50), // Cylinder shape with bold blue border
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF06A6DD), // #06A6DD
                              Color(0xFF1C66AD), // #1C66AD
                            ],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // White background inside the border
                            borderRadius: BorderRadius.circular(
                                50), // Keep the inner container cylindrical
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Action for video button
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .white, // Button background should be white
                              shadowColor:
                                  Colors.transparent, // Remove button shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50), // Cylindrical shape
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12), // Padding inside the button
                            ),
                            child: Center(
                              child: Text(
                                'Watch Intro Video',
                                style: TextStyle(
                                  color: Color(0xFF1C66AD), // Blue text
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16), // Spacing below the video button

                    // Property name, heart icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Small cottage in Hyderabad',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.favorite_border),
                      ],
                    ),
                    Text(
                      'view of begmati',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),

                    // Rating and Room count
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16),
                            SizedBox(
                                width: 5), // Small space between icon and text
                            Text('4.1 (66 reviews)'),
                          ],
                        ),
                        SizedBox(width: 100),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/bed.png', // Load image from assets
                              width:
                                  24, // Set width of the image (adjust as needed)
                              height: 24, // Set height of the image
                            ),
                            SizedBox(width: 8), // Space between icon and text
                            Text('2 Room',
                                style: TextStyle(
                                    fontSize: 16)), // Text next to the image
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Location and Property size
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey),
                            SizedBox(
                                width: 4), // Small space between icon and text
                            Text('Kapan, Jorpati'),
                          ],
                        ),
                        SizedBox(width: 105),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/home.png', // Load image from assets
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text('874 m²',
                                style: TextStyle(
                                    fontSize: 16)), // Text next to the image
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Owner info with avatar and call button
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
                              'Anil',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('Property owner'),
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Background color (you can customize)
                            shape: BoxShape
                                .rectangle, // Ensures the container is a square
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // How wide the shadow spreads
                                blurRadius: 5, // Blur radius of the shadow
                                offset:
                                    Offset(0, 3), // Offset of the shadow (x, y)
                              ),
                            ],
                          ),
                          width:
                              40, // Define the width and height to create a square shape
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

                    // Tabs for Description, Gallery, Review
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = 0;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedTabIndex == 0
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              if (selectedTabIndex == 0)
                                Container(
                                  height: 2,
                                  width: 60,
                                  color: Colors.blue,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = 1;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedTabIndex == 1
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              if (selectedTabIndex == 1)
                                Container(
                                  height: 2,
                                  width: 60,
                                  color: Colors.blue,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = 2;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'Review',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedTabIndex == 2
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              if (selectedTabIndex == 2)
                                Container(
                                  height: 2,
                                  width: 60,
                                  color: Colors.blue,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Content based on selected tab
                    if (selectedTabIndex == 0) buildDescriptionContent(),
                    if (selectedTabIndex == 1) buildGalleryContent(),
                    if (selectedTabIndex == 2) buildReviewContent(),
                  ],
                ),
              ),
            ],
          ),

          // Bottom fixed rent and call button section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures the text and button are spaced
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Aligns the columns at the start of the row
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Aligns text to the left inside the column
                    children: [
                      Text(
                        '₹10,000 / month',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height:
                              4), // Small space between rent and payment estimation
                      Text(
                        'Payment estimation',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF06A6DD), // #06A6DD
                          Color(0xFF1C66AD), // #1C66AD
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                          30), // Make it fully rounded (cylindrical)
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call button functionality here
                      },
                      // Icon color set to white
                      label: Text(
                        'Call',
                        style: TextStyle(
                            color: Colors.white), // Text color set to white
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Button background transparent to show gradient
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                        padding: EdgeInsets.symmetric(
                            horizontal: 45, vertical: 20), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Cylindrical shape
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
