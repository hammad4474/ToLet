import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/prizeRange_widget.dart';
import 'package:tolet/screens/tenant/propertyfacilities.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedPropertyType = 'House'; // Default selected property type

  double _minPrice = 10000;
  double _maxPrice = 30000;
  String _selectedTimePeriod = 'Monthly';


  Map<String, bool> facilities = {
    'Furnished': false,
    'WiFi': false,
    'Kitchen': false,
    'Self Check-in': false,
    'Free parking': false,
    'Air conditioner': false,
    'Security': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Keeps the color fixed
        elevation: 0, // Removes shadow
        toolbarHeight: 70, // Fixed height
        title: const Text('Filter', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyTypeSection(),


                const SizedBox(height: 16),
                PriceRangeWidget(),
                const SizedBox(height: 16),
                PropertyFacilities(),
                const SizedBox(height: 100), // Add spacing at the bottom for the action buttons
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white, // Background color for the button section
              child: _buildActionButtons(),
            ),
          ),
        ],
      ),
    );
  }

  // Property Type Section
  Widget _buildPropertyTypeSection() {
    final propertyTypes = ['Any', 'House', 'Hostel', 'Cabin', 'Flats', 'Shops'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: propertyTypes.length,
            itemBuilder: (context, index) {
              return _buildPropertyTypeButton(propertyTypes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyTypeButton(String type) {
    final bool isSelected = _selectedPropertyType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPropertyType = type; // Update the selected property type
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Colors.lightBlue, Colors.blue],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )
              : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 5)]
              : [],
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              // Reset all values to default
              _selectedPropertyType = 'House'; // Reset to default value (or whatever you choose)
              // Reset other states here if necessary
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset all'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle show results action
          },
          child: const Text('Show results'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
      ],
    );
  }
}
