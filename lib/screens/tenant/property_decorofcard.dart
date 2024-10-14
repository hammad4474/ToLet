import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';
import 'property_listofcard.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsScreen(),
          ),
        );
      },
      child: Container(
        width: 359,
        height: 189, // Fixed height for the card
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left section (Image)
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.asset(
                    property.imageUrl, // Replace with your image URL
                    fit: BoxFit.cover,
                    height: 189, // Ensure the image takes up the full height of the card
                    width: 108, // Adjust the image width
                  ),
                ),
              ),
              // Middle section (Property Details)
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 189, // Make sure the middle section also respects the card height
                  child: Column(
                    mainAxisSize: MainAxisSize.max, // Ensure content fills the height
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child:Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        property.city,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Row(
                        children: [
                          Icon(Icons.bed, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${property.rooms}', style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 8),
                          Icon(Icons.square_foot, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${property.area}', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        '${property.price} / month',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(), // Push the 'Verified' text to the bottom
                      Text(
                        property.isVerified ? "Verified" : "Not Verified",
                        style: TextStyle(
                          fontSize: 14,
                          color: property.isVerified ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right section (Icons)
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 189, // Make sure the right section also respects the card height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Evenly space icons vertically
                    children: [
                      Image.asset(
                        'assets/icons/verified.png',
                        height: 24,
                        width: 24,
                      ),
                      Image.asset(
                        'assets/icons/saved.png',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
