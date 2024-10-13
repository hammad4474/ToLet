import 'package:flutter/material.dart';

// This function builds the review content wrapped in a SingleChildScrollView
Widget buildReviewContent() {
  return Container(
    height: 450,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildReviewTile(
            'Sandeep S.',
            'Great view of garden from window and best services from owner. Satisfied!',
            '2 months ago',
            5,
            1,
            2,
            [
              'assets/images/pd.png',
              'assets/images/pd.png'
            ], // Images from assets
          ),
          buildReviewTile(
            'John D.',
            'The cottage was cozy and had everything we needed. Highly recommend!',
            '1 month ago',
            4,
            3,
            0,
            ['assets/images/pd.png'], // Example images from assets
          ),
          // Add more review tiles if necessary
        ],
      ),
    ),
  );
}

// Function to build individual review tiles
Widget buildReviewTile(
  String reviewerName,
  String reviewText,
  String timestamp,
  int rating,
  int helpfulCount,
  int notHelpfulCount,
  List<String> imagePaths,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // First row: Avatar + Name in bold + Timestamp on the right
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/dp.png'), // Avatar image from assets
          ),
          SizedBox(width: 10), // Spacing between avatar and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reviewerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ), // Bold reviewer name
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ), // Timestamp aligned to right
                    ),
                  ],
                ),
                SizedBox(height: 4), // Space between name and review text

                // The review text will wrap automatically if it exceeds the width
                Text(
                  reviewText,
                  softWrap:
                      true, // Ensures text wraps to the next line automatically
                ),
              ],
            ),
          ),
        ],
      ),

      // Second row: Star rating + Helpful/Like/Dislike buttons
      Padding(
        padding: const EdgeInsets.only(
            left: 48.0, top: 4.0), // Align stars and feedback
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildStarRating(rating), // Star rating widget
            Row(
              children: [
                Text('Helpful?'),
                TextButton.icon(
                  onPressed: () {}, // Like button
                  icon: Icon(Icons.thumb_up_alt_outlined,
                      size: 10, color: Colors.black),
                  label: Text(helpfulCount.toString()),
                ),
                TextButton.icon(
                  onPressed: () {}, // Dislike button
                  icon: Icon(Icons.thumb_down_alt_outlined,
                      size: 10, color: Colors.black),
                  label: Text(notHelpfulCount.toString()),
                ),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 8), // Spacing before image row

      // Third row: Display review images from assets
      buildImageRow(imagePaths),

      Divider(), // Divider at the bottom of the review
    ],
  );
}

// Function to build a row of images for the review
Widget buildImageRow(List<String> imagePaths) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      children: imagePaths.map((path) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            child: Image.asset(
              path,
              width: 100,
              height: 100,
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// Function to build star ratings
Widget buildStarRating(int rating) {
  // Calculate the average rating as a double
  double averageRating = rating.toDouble();

  return Row(
    children: [
      // Generate stars based on the rating
      ...List.generate(5, (index) {
        return Icon(
          index < rating
              ? Icons.star
              : Icons.star_border, // Show stars based on rating
          color: Colors.yellow,
          size: 16,
        );
      }),
      SizedBox(width: 4), // Space between stars and rating text
      Text(
        averageRating.toStringAsFixed(1), // Format rating to one decimal place
        style: TextStyle(
            fontSize: 13, color: Colors.grey), // Adjust text style as needed
      ),
    ],
  );
}
