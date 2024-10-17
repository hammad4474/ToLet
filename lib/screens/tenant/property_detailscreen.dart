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
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 18),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/share.png',
                  width: 24,
                  height: 24,
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView(
                        children: [
                          Image.asset('assets/images/pd.png', fit: BoxFit.cover),
                          Image.network('https://via.placeholder.com/400', fit: BoxFit.cover),
                          Image.network('https://via.placeholder.com/400', fit: BoxFit.cover),
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
                      Center(
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF06A6DD),
                                Color(0xFF1C66AD),
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Action for video button
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Center(
                                child: Text(
                                  'Watch Intro Video',
                                  style: TextStyle(
                                    color: Color(0xFF1C66AD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Small cottage in Hyderabad',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.favorite_border),
                        ],
                      ),
                      Text(
                        'view of begmati',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              SizedBox(width: 5),
                              Text('4.1 (66 reviews)'),
                            ],
                          ),
                          SizedBox(width: 100),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/bed.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text('2 Room', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('Kapan, Jorpati'),
                            ],
                          ),
                          SizedBox(width: 105),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/home.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text('874 m²', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/delhi.png'),
                            radius: 24,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anil',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text('Property owner'),
                            ],
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            width: 40,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildTab('Description', 0),
                          buildTab('Gallery', 1),
                          buildTab('Review', 2),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (selectedTabIndex == 0) buildDescriptionContent(),
                      if (selectedTabIndex == 1) buildGalleryContent(),
                      if (selectedTabIndex == 2) buildReviewContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹10,000 / month',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Payment estimation',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF06A6DD),
                      Color(0xFF1C66AD),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Call button functionality here
                  },
                  label: Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.phone, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedTabIndex == index ? Colors.blue : Colors.black,
            ),
          ),
          if (selectedTabIndex == index)
            Container(
              height: 2,
              width: 60,
              color: Colors.blue,
            )
        ],
      ),
    );
  }

}
