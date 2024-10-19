import 'package:flutter/material.dart';
import 'package:tolet/widgets/constcolor.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedPropertyType = 'null'; // Default selected property type

  double _minPrice = 10000;
  double _maxPrice = 30000;
  String _selectedTimePeriod = 'null';

  Map<String, bool> facilities = {
    'Furnished': false,
    'WiFi': true,
    'Kitchen': false,
    'Self Check-in': false,
    'Free parking': false,
    'Air conditioner': true,
    'Security': false,
  };

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
        title: Container(
          height: 40.0, // Set a suitable height for the search bar
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background for the search bar
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.search, color: Colors.black54), // Search icon
              ),
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center, // Center the text vertically
                  decoration: InputDecoration(
                    hintText: 'Hyderabad',
                    border: InputBorder.none, // Remove the underline
                    isCollapsed: true, // Reduce the padding around the hint text
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Add padding for better alignment
                  ),
                  style: TextStyle(color: Colors.grey[200]),
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.tune, color: Colors.black), // Filter icon
              //   onPressed: () {
              //     // Handle filter button press
              //   },
              // ),
            ],
          ),
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
                  _buildPropertyTypeSection(),
                  const SizedBox(height: 16),
                  _buildPriceRangeWidget(),
                  const SizedBox(height: 16),
                  _buildPropertyFacilities(facilities), // Pass facilities map
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

  // Property Type Section
  Widget _buildPropertyTypeSection() {
    final propertyTypes = ['Any', 'House', 'Hostel', 'Cabin', 'Flats', 'Shops'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            colors: [Color(constcolor.App_lightblue_color), Color(constcolor.App_blue_color)],
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
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price range',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('₹${_minPrice.toInt()} - ₹${_maxPrice.toInt()} / month',
            style: TextStyle(color: Colors.grey)),
        SizedBox(height: 16),
        _buildPriceGraph(),
        _buildPriceSlider(),
        _buildTimePeriodSelector(),
      ],
    );
  }

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
      min: 0,
      max: 50000,
      divisions: 10,
      activeColor: Color(constcolor.App_blue_color),
      onChanged: (RangeValues values) {
        setState(() {
          _minPrice = values.start;
          _maxPrice = values.end;
        });
      },
    );
  }

  // Time period buttons
  Widget _buildTimePeriodSelector() {
    final propertyweeks = ['Daily', 'Weekly', 'Monthly', 'Annually'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Rental Time Period',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          height: 40, // Set a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: propertyweeks.length,
            itemBuilder: (context, index) {
              return _buildTimePeriodButton(propertyweeks[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimePeriodButton(String label) {
    bool isSelected = _selectedTimePeriod == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimePeriod = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [Color(constcolor.App_lightblue_color), Color(constcolor.App_blue_color)],
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
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
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
              _selectedPropertyType =
              'null';
              _selectedTimePeriod = 'null';
              _minPrice=0;
              _maxPrice=1000;
              facilities = {
                'Furnished': false,
                'WiFi': false,
                'Kitchen': false,
                'Self Check-in': false,
                'Free parking': false,
                'Air conditioner': false,
                'Security': false,
              };
              // Reset to default value (or whatever you choose)
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Set the border radius to 20
            ),
          ),
        ),

      ],
    );
  }
}


class PriceGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height); // Starting point (bottom-left)

    // Draw the curve smoothly
    path.lineTo(0, size.height * 0.8); // Start by moving up

    // Adjust the control points to form a more natural curve
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.4, size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.8, size.width * 0.6, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.4);

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
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjust padding as needed
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(
            colors: [Color(constcolor.App_lightblue_color), Color(constcolor.App_blue_color)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )
              : null,
          color: active ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: active
              ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 5)]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

