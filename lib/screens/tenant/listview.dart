import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set fixed width for the card
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image Placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(property.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    property.city,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bed, size: 16),
                      SizedBox(width: 4),
                      Text('${property.rooms}'),
                      SizedBox(width: 8),
                      Icon(Icons.square_foot, size: 16),
                      SizedBox(width: 4),
                      Text('${property.area}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    property.isVerified ? "✔️ Verified" : "Not Verified",
                    style: TextStyle(
                      fontSize: 12,
                      color: property.isVerified ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    property.price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
}
