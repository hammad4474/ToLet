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
    // Define fixed sizes
    const double avatarSize = 60.0; // Fixed size for avatar images
    const double fontSize = 14.0; // Fixed font size
    const int gridCrossAxisCount = 3; // Keep the same grid structure for all orientations
    const double gridSpacing = 10.0; // Fixed grid spacing

    return Dialog(
      backgroundColor: Color(0xffd9d9d9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 350.0, // Fixed dialog width
        constraints: BoxConstraints(
          maxHeight: 500.0, // Set a maximum height for the dialog
        ),
        child: SingleChildScrollView( // Enable scrolling for smaller devices
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select your city',
                  style: TextStyle(
                    fontSize: 18.0, // Fixed font size for title
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0), // Fixed height spacing
                GridView.builder(
                  shrinkWrap: true, // Let GridView take minimum space
                  physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCrossAxisCount, // Keep a consistent grid count
                    crossAxisSpacing: gridSpacing, // Fixed cross-axis spacing
                    mainAxisSpacing: gridSpacing, // Fixed main-axis spacing
                    childAspectRatio: 1.0, // Ensure square cells
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
                                width: avatarSize, // Fixed width for all images
                                height: avatarSize, // Fixed height for all images
                                child: FittedBox(
                                  fit: BoxFit.cover, // Ensure the image fills the container
                                  child: Image.asset(
                                    widget.cities[index]['image']!,
                                    fit: BoxFit.cover,
                                    width: avatarSize, // Ensure image width is fixed
                                    height: avatarSize, // Ensure image height is fixed
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0), // Fixed height spacing
                            Text(
                              widget.cities[index]['name']!,
                              style: TextStyle(
                                fontSize: fontSize, // Fixed font size
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
        ),
      ),
    );
  }
}
