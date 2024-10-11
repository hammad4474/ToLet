import 'package:flutter/material.dart';
Widget buildGalleryContent() {
  return SingleChildScrollView(
    child: Column(
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

        // Grid of images with curved edges
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          physics: NeverScrollableScrollPhysics(), // Disable scrolling on GridView
          children: List.generate(
            9,
                (index) => ClipRRect(
              borderRadius: BorderRadius.circular(15), // Curved edges for the images
              child: Image.asset(
                'assets/images/pd.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Set height to keep the grid size consistent
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
