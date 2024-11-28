import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Function(List<QueryDocumentSnapshot>) onFilterApplied;
  final Function onReset;

  FilterScreen({required this.onFilterApplied, required this.onReset});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _minPrice = 10000;
  double _maxPrice = 30000;
  Map<String, bool> facilities = {
    'Car Parking': false,
    'Furnished': true,
    'Gym Fit': false,
    'Kitchen': false,
    'Laundry': false,
    'WI-fi': true,
    'Sports': false,
    'Pet center': false,
  };

  List<QueryDocumentSnapshot> _filteredProperties = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          'Filter Now',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeText(),
                  const SizedBox(height: 16),
                  _buildPriceGraph(),
                  const SizedBox(height: 16),
                  _buildPriceSlider(),
                  const SizedBox(height: 16),
                  _buildPropertyFacilities(facilities),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white, // Background color for the button section
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  // Price Graph and Range Slider
  Widget _buildPriceGraph() {
    return Container(
      height: 100, // Set appropriate height for the graph
      width: double.infinity, // Graph spans full width
      child: CustomPaint(
        painter: PriceGraphPainter(),
      ),
    );
  }

  Widget _buildPriceSlider() {
    return RangeSlider(
      values: RangeValues(_minPrice, _maxPrice),
      min: 10000,
      max: 60000,
      divisions: 10,
      activeColor: Color(0xff192747),
      onChanged: (RangeValues values) {
        setState(() {
          _minPrice = values.start;
          _maxPrice = values.end;
        });
      },
    );
  }

  Widget _buildPriceRangeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Price range: ₹${_minPrice.toStringAsFixed(0)} - ₹${_maxPrice.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Facilities Section
  Widget _buildPropertyFacilities(Map<String, bool> facilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property Facilities',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: facilities.keys.map((facility) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  facilities[facility] = !facilities[facility]!;
                });
              },
              child: FacilityChip(
                label: facility,
                active: facilities[facility]!,
              ),
            );
          }).toList(),
        ),
      ],
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
              _minPrice = 10000;
              _maxPrice = 30000;
              facilities = {
                'Car Parking': false,
                'Furnished': true,
                'Gym Fit': false,
                'Kitchen': false,
                'Laundry': false,
                'WI-fi': true,
                'Sports': false,
                'Pet center': false,
              };
            });
            // Call onReset function to notify the parent widget
            widget.onReset();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset all'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              // Fetch the filtered properties asynchronously
              await _fetchFilteredProperties();

              // Pass the filtered properties back to the parent widget (SearchPropertyScreen)
              widget.onFilterApplied(_filteredProperties);

              // Optionally, you can log or print the filtered properties count to ensure the data is correct
              print(
                  "Filtered Properties: ${_filteredProperties.length} results");

              // Close the dialog by popping the dialog context
              Navigator.pop(
                  context); // Close the dialog using the correct context
            } catch (e) {
              // Handle any errors that might occur during the fetch process
              print("Error fetching properties: $e");
            }
          },
          child: const Text('Show results'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Set the border radius to 20
            ),
          ),
        ),
      ],
    );
  }

  // Fetch the filtered properties from Firestore
  Future<void> _fetchFilteredProperties() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('propertiesAll')
        .where('price', isGreaterThanOrEqualTo: _minPrice.toString())
        .where('price', isLessThanOrEqualTo: _maxPrice.toString())
        .get();

    print(
        'Snapshot count: ${snapshot.docs.length}'); // Debugging line to check the number of docs

    List<QueryDocumentSnapshot> filteredProperties = snapshot.docs.where((doc) {
      // Get the document data as a Map<String, dynamic>
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

      // Debugging: Print the document's price and facilities fields
      print(
          'Checking doc: ${docData['price']} | Facilities: ${docData['facilities']}');

      // Ensure 'price' is a valid field and properly converted to double
      double propertyPrice =
          double.tryParse(docData['price'].toString()) ?? 0.0;

      // Ensure 'facilities' is a list of strings, fallback to empty list if not present
      List<String> propertyFacilities = docData['facilities'] != null
          ? List<String>.from(docData['facilities'])
          : [];

      // Filter by price and facilities
      bool matchesFacilities = facilities.keys.every((facility) {
        if (facilities[facility]!) {
          return propertyFacilities.contains(facility);
        }
        return true; // If facility is not selected, don't filter by it
      });

      return propertyPrice >= _minPrice &&
          propertyPrice <= _maxPrice &&
          matchesFacilities;
    }).toList();

    print('Filtered Properties count: ${filteredProperties.length}');

    setState(() {
      _filteredProperties = filteredProperties;
    });
  }
}

class PriceGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff192760)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height); // Starting point (bottom-left)

    // Draw the curve smoothly
    path.lineTo(0, size.height * 0.8); // Start by moving up

    // Adjust the control points to form a more natural curve
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.4,
        size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.8,
        size.width * 0.6, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.2, size.width, size.height * 0.4);

    path.lineTo(size.width, size.height); // Complete the path at bottom-right
    path.close();

    canvas.drawPath(path, paint); // Draw the filled path with the paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FacilityChip extends StatelessWidget {
  final String label;
  final bool active;

  FacilityChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: active ? Colors.black : Colors.grey[300],
      labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
    );
  }
}
