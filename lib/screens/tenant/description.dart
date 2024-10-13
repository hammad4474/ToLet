import 'package:flutter/material.dart';

Widget buildDescriptionContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Home Facilities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'See all facilities',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 16),
      // Facilities icons in two rows
      Column(
        children: [
          // First row with 4 icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildFacilityIcon('assets/icons/car.png', 'Car Parking'),
              buildFacilityIcon('assets/icons/swim.png', 'Swimming'),
              buildFacilityIcon('assets/icons/gym.png', 'Gym & Fit'),
              buildFacilityIcon('assets/icons/restaurant.png', 'Restaurant'),
            ],
          ),
          SizedBox(height: 16), // Spacing between the rows
          // Second row with 4 icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildFacilityIcon('assets/icons/wifi.png', 'Wi-Fi'),
              buildFacilityIcon('assets/icons/pets.png', 'Pet Center'),
              buildFacilityIcon('assets/icons/running.png', 'Sports Club'),
              buildFacilityIcon('assets/icons/laundry.png', 'Laundry'),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget buildFacilityIcon(String iconPath, String label) {
  return SingleChildScrollView(
    child: Container(
      width: 70, // Adjust width of the container
      height: 65, // Adjust height to accommodate both icon and text
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Curved edges for the box
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Shadow color
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 10, // Blur radius of the shadow
            offset: Offset(0, 3), // Shadow position (x, y)
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Aligns icon and text in the center
          children: [
            Image.asset(
              iconPath, // Icon from asset
              width: 32, // Adjust the size of the icon
              height: 32,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8), // Space between the icon and text
            Text(
              label,
              style: TextStyle(fontSize: 12), // Text size for the label
              textAlign: TextAlign.center, // Align the text to the center
            ),
          ],
        ),
      ),
    ),
  );
}
