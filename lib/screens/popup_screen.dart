import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tolet/widgets/constcolor.dart'; // For adding a delay

class CitySelectionDialog extends StatefulWidget {
  final List<Map<String, String>> cities;
  final Function(String) onCitySelected; // Callback function to pass selected city to parent

  CitySelectionDialog({required this.cities, required this.onCitySelected});

  @override
  _CitySelectionDialogState createState() => _CitySelectionDialogState();
}

class _CitySelectionDialogState extends State<CitySelectionDialog> {
  int _selectedIndex = -1; // Store the index of the selected city

  // Method to handle the city selection and delay
  void _onCitySelected(int index) async {
    setState(() {
      _selectedIndex = index; // Update the selected city index
    });

    // Delay for 3 seconds to "freeze" the dialog
    await Future.delayed(Duration(seconds: 2));

    // Pass the selected city back to the parent widget
    widget.onCitySelected(widget.cities[index]['name']!);

    // Close the dialog after the delay
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive UI
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate dynamic sizing based on screen width and height
    final avatarSize = screenWidth * 0.15; // 15% of screen width
    final gridCrossAxisCount = (screenWidth > 600) ? 4 : 3; // Adjust grid layout based on width
    final gridSpacing = screenWidth * 0.03; // 3% of screen width

    return Dialog(
      backgroundColor: Color(0xffd9d9d9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select your city',
              style: TextStyle(
                fontSize: screenWidth * 0.05, // Dynamic font size based on width
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive height spacing
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount, // Responsive grid count
                crossAxisSpacing: gridSpacing, // Responsive cross-axis spacing
                mainAxisSpacing: gridSpacing, // Responsive main-axis spacing
              ),
              itemCount: widget.cities.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index; // Check if the city is selected
                return GestureDetector(
                  onTap: () {
                    _onCitySelected(index); // Call the method to handle selection
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click, // Change the cursor on hover
                    child: Column(
                      children: [
                        // CircleAvatar with BoxFit.cover to fit the image within the frame
                        ClipOval(
                          child: Container(
                            width: avatarSize, // Dynamic width for all images
                            height: avatarSize, // Dynamic height for all images
                            child: FittedBox(
                              fit: BoxFit.cover, // Ensure the image fills the container
                              child: Image.asset(
                                widget.cities[index]['image']!,
                                fit: BoxFit.cover,
                                width: avatarSize, // Ensure image width is responsive
                                height: avatarSize, // Ensure image height is responsive
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01), // Responsive height spacing
                        Text(
                          widget.cities[index]['name']!,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03, // Dynamic font size based on width
                            color: isSelected ? Color(constcolor.App_blue_color) : Colors.black, // Change color if selected
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Bold if selected
                            decoration: isSelected ? TextDecoration.underline : TextDecoration.none, // Underline if selected
                            decorationColor: Color(constcolor.App_blue_color), // Set underline color to blue
                            decorationThickness: 2.0, // Make underline thicker
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
