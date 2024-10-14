import 'package:flutter/material.dart';
import 'dart:async'; // For adding a delay

class CitySelectionDialog extends StatefulWidget {
  final List<Map<String, String>> cities;
  final Function(String)
      onCitySelected; // Callback function to pass selected city to parent

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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.cities.length,
              itemBuilder: (context, index) {
                bool isSelected =
                    _selectedIndex == index; // Check if the city is selected
                return GestureDetector(
                  onTap: () {
                    _onCitySelected(
                        index); // Call the method to handle selection
                  },
                  child: MouseRegion(
                    cursor:
                        SystemMouseCursors.click, // Change the cursor on hover
                    child: Column(
                      children: [
                        // CircleAvatar with BoxFit.cover to fit the image within the frame
                        ClipOval(
                          child: Container(
                            width: 80, // Fixed width for all images
                            height: 80, // Fixed height for all images
                            child: FittedBox(
                              fit: BoxFit
                                  .fill, // Ensure the image fills the container
                              child: Image.asset(
                                widget.cities[index]['image']!,
                                fit: BoxFit.fill,
                                width: 80, // Ensure image width is same
                                height: 80, // Ensure image height is same
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),
                        Text(
                          widget.cities[index]['name']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.blue
                                : Colors
                                    .black, // Change color to blue if selected
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal, // Make it bold if selected
                            decoration: isSelected
                                ? TextDecoration.underline
                                : TextDecoration.none, // Underline if selected
                            decorationColor:
                                Colors.blue, // Set underline color to blue
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
