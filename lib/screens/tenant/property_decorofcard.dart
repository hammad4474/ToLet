// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// import 'package:tolet/screens/tenant/property_detailscreen.dart';
// import 'package:tolet/screens/tenant/property_listofcard.dart';

// class PropertyCard extends StatelessWidget {
//   final Property property;
//     bool isVerified = true;


//    PropertyCard({
//     Key? key,
//     required this.property,
//     required this.isVerified,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PropertyDetailsScreen(
//                 //property: property
//                 ), // Pass property data to details screen
//           ),
//         );
//       },
//       child: Container(
//         width: 359,
//         height: 189,
//         margin: EdgeInsets.symmetric(horizontal: 8.0),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     bottomLeft: Radius.circular(15),
//                   ),
//                   child: Image.asset(
//                     property.imageURL,
//                     fit: BoxFit.cover,
//                     height: 189,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         property..propertyTitle,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         property.city,
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.bed, size: 16, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text('${property.bhk}',
//                               style: TextStyle(color: Colors.grey)),
//                           SizedBox(width: 8),
//                           Icon(Icons.square_foot, size: 16, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text('${property.area}',
//                               style: TextStyle(color: Colors.grey)),
//                         ],
//                       ),
//                       Text(
//                         '${property.price} / month',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       Text(
//                         property.isVerified ? "Verified" : "Not Verified",
//                         style: TextStyle(
//                           color:
//                               property.isVerified ? Colors.green : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset('assets/icons/verified.png', height: 24),
//                     Image.asset('assets/icons/saved.png', height: 24),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
