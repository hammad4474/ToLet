import 'package:flutter/material.dart';

Widget buildGalleryContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: const [
          Text(
            'Gallery',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '(400)',
            style: TextStyle(
              color: Colors.blue, // Blue for '(400)'
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 8), // Space between text and the grid
      Container(
        height: 900,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          physics: AlwaysScrollableScrollPhysics(),
          childAspectRatio: 1,
          children: List.generate(
            8,
            (index) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/pd.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
          ),
        ),
      )
    ],
  );
}
