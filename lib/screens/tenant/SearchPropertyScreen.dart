import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tolet/screens/tenant/listview.dart';
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

  void _showPropertyDetails(Map<String, dynamic> property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(property: property),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Property')),
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
            initialChildSize: 0.5, // Increase initial height to 50%
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
                  children: [
                    // Header with "Showing 72 results" text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Showing 72 results",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final propertyData = properties[index];
                          final property = Property.fromMap(
                              propertyData);
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

  const SearchPropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailScreen(property: property),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(8.0),
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
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(property['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Right Section: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Title
                  Text(
                    property['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // City
                  Text(
                    property['city'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Property Details (Rooms, Area)
                  Row(
                    children: [
                      Icon(Icons.bed, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${property['rooms']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.square_foot, size: 16, color: Colors.grey),
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
                      // Verified Badge
                      Icon(
                        property['isVerified'] ? Icons.verified : Icons.cancel,
                        color: property['isVerified'] ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property['isVerified'] ? " Verified" : "Not Verified",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({Key? key, required this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              property['imageUrl'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              property['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(property['city'], style: TextStyle(fontSize: 18)),
            Text(property['price'], style: TextStyle(fontSize: 18)),
            Text(property['rooms'], style: TextStyle(fontSize: 18)),
            Text(property['area'], style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
