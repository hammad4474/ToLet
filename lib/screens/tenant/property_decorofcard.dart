import 'package:flutter/material.dart';
import 'property_listofcard.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      return Container(
        width: 359, // Set fixed width for the card
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: screenHeight * 0.35,
            child: Row(children: [
              // Left section (Text and Button with gradient background)
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.asset(
                    property.imageUrl, // Replace with your image URL
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: screenWidth *
                        0.45, // Adjust image width based on screen size
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property Title
                      Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),

                      // City
                      Text(
                        property.city,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Property Details (Rooms, Area)
                      Row(
                        children: [
                          Icon(Icons.bed, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${property.rooms}',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 8),
                          Icon(Icons.square_foot, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${property.area}',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Price and Verified Status
                      Row(
                        children: [
                          // Price
                          Text(
                            property.price + '/ month',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Spacer(),
                          // Verified Badge
                          Text(
                            property.isVerified ? " Verified" : "Not Verified",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Right section (Image)

              // child:Column(
              //  // crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     // Property Image
              //     ClipRRect(
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(10),
              //         topRight: Radius.circular(10),
              //       ),
              //
              //       child: Image.network(
              //         property.imageUrl, // Replace with your image URL
              //         height: 120,
              //         width: 80,
              //         fit: BoxFit.fitHeight,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           // Property Title
              //           Text(
              //           property.title,
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black87,
              //             ),
              //           ),
              //           SizedBox(height: 4),
              //
              //           // City
              //           Text(
              //             property.city,
              //             style: TextStyle(
              //               fontSize: 14,
              //               color: Colors.grey,
              //             ),
              //           ),
              //           SizedBox(height: 4),
              //
              //           // Property Details (Rooms, Area)
              //           Row(
              //             children: [
              //               Icon(Icons.bed, size: 16, color: Colors.grey),
              //               SizedBox(width: 4),
              //               Text('${property.rooms}', style: TextStyle(color: Colors.grey)),
              //               SizedBox(width: 8),
              //               Icon(Icons.square_foot, size: 16, color: Colors.grey),
              //               SizedBox(width: 4),
              //               Text('${property.area}', style: TextStyle(color: Colors.grey)),
              //             ],
              //           ),
              //           SizedBox(height: 8),
              //
              //           // Price and Verified Status
              //           Row(
              //             children: [
              //               // Price
              //               Text(
              //             property.price+ '/ month',
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black87,
              //                 ),
              //               ),
              //               Spacer(),
              //               // Verified Badge
              //               Text(
              //                   property.isVerified ? " Verified" : "Not Verified",
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   color: Colors.green,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ]),
          ),
        ),
      );
    }
  }
}
