import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/filter_screen.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tolet/screens/tenant/listview.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';

class SearchPropertyScreen extends StatefulWidget {
  const SearchPropertyScreen({Key? key}) : super(key: key);

  @override
  _SearchPropertyScreenState createState() => _SearchPropertyScreenState();
}

class _SearchPropertyScreenState extends State<SearchPropertyScreen> {
  // late GoogleMapController mapController;
  // final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> properties = [
    {
      "title": "Small cottage with great view of Bagmati",
      "city": "Hyderabad",
      "price": "₹10,000",
      "isVerified": true,
      "rooms": "2 bedrooms",
      "rating": "2.3",
      "area": "673 m²",
      "lat": 17.3850,
      "long": 78.4867,
      "imageUrl": "assets/images/home2.png",
    },
    {
      "title": "Luxury Apartment",
      "city": "Hyderabad",
      "price": "₹12,000",
      "isVerified": false,
      "rooms": "3 bedrooms",
      "rating": "5.6",
      "area": "800 m²",
      "lat": 17.4220,
      "long": 78.4570,
      "imageUrl": "assets/images/home1.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    // _addMarkers();
  }

  // void _addMarkers() {
  //   for (var property in properties) {
  //     final marker = Marker(
  //       markerId: MarkerId(property['title']),
  //       position: LatLng(property['lat'], property['long']),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //       onTap: () {
  //         _showPropertyDetails(property);
  //       },
  //     );
  //     _markers.add(marker);
  //   }
  // }

  // void _showPropertyDetails(Map<String, dynamic> property) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PropertyDetailScreen(property: property),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false, // Disable default back button
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          title: Row(
            children: <Widget>[
              // Logo
              SizedBox(width: 10),
              IconButton(
                   icon: const Icon(Icons.arrow_back, color: Colors.black),
                   onPressed: () {
                     Navigator.pop(context);
                     }, // Go back to the previous screen},
                 ),
              SizedBox(width: 10),

              // Search Bar with tap detection
              Expanded(// Trigger callback when tapped
                  child: Container(
                    height: 45,
                    constraints: BoxConstraints(
                        maxWidth: 500), // Limit max width of search bar
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.search, color: Colors.grey),
                        ),
                        Expanded(
                          child: Text(
                            'Search address, city, location',
                            style:
                            TextStyle(color: Colors.grey), // Placeholder style
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Tune Icon on the right
              IconButton(
                icon: Image.asset(
                  'assets/icons/custum_tune_icon.png', // Replace with your actual custom icon asset
                  height: 40,
                  width: 40,
                ),

                onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => FilterScreen()),
                     );
                   },
    ),
            ],
          ),
        ),
      body: Stack(
        children: [
          // GoogleMap(
          //   onMapCreated: (GoogleMapController controller) {
          //     mapController = controller;
          //   },
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(17.3850, 78.4867),
          //     zoom: 12,
          //   ),
          //   markers: _markers,
          // ),
          // Replace static image with google map
          Image.asset(
            'assets/images/static_map.png', // Use your static map image here
            fit: BoxFit.fill,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6, // Increase initial height to 50%
            minChildSize: 0.5,
            maxChildSize: 0.9, // Increase max height to 90%
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 30),
                          child: Text(
                            "Showing 72 results",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/icons/ic_sort.png',
                          height: 16, // Set the desired size
                          width: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Sort",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    // Header with "Showing 72 results" text

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final propertyData = properties[index];
                          final property = Property.fromMap(propertyData);
                          return SearchPropertyCard(property: propertyData);
                          // return PropertyCard(property: property);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SearchPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;

  const SearchPropertyCard({Key? key, required this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsScreen(
              area: '',
              bhk: '',
              imageURL: '',
              isVerified: false,
              location: '',
              price: '',
              title: '',
              owner: '',
              propertyId: '',
              //  propertyId: '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Section: Image
            Container(
              width: screenWidth * 0.3,
              height: 189,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.zero),
                image: DecorationImage(
                  image: AssetImage(property['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Right Section: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/rating.png',
                        height: 16, // Set the desired size
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property['rating']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Property Title
                  Text(
                    property['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // City
                  Text(
                    property['city'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Property Details (Rooms, Area)
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/ic_bed.png',
                        height: 16, // Set the desired size
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property['rooms']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/icons/ic_area.png',
                        height: 16, // Set the desired size
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property['area']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price and Verified Status
                  Row(
                    children: [
                      // Price
                      Text(
                        property['price'] + '/ month',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/icons/ic_heart.png',
                        height: 16, // Set the desired size
                        width: 16,
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SearchPropertyCard extends StatelessWidget {
//   final Map<String, dynamic> property;
//
//   const SearchPropertyCard({Key? key, required this.property}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PropertyDetailScreen(property: property),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Left Section: Image
//             Container(
//               width: MediaQuery.of(context).size.width * 0.3,
//               height: 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: AssetImage(property['imageUrl']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             // Right Section: Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     property['title'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(property['city']),
//                   SizedBox(height: 4),
//                   Text(property['price']),
//                   SizedBox(height: 4),
//                   Text(property['rooms']),
//                   SizedBox(height: 4),
//                   Text(property['area']),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PropertyDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> property;
//
//   const PropertyDetailScreen({Key? key, required this.property})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(property['title'])),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               property['imageUrl'],
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 16),
//             Text(
//               property['title'],
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(property['city'], style: TextStyle(fontSize: 18)),
//             Text(property['price'], style: TextStyle(fontSize: 18)),
//             Text(property['rooms'], style: TextStyle(fontSize: 18)),
//             Text(property['area'], style: TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
