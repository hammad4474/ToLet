import 'package:flutter/material.dart';
import 'package:tolet/screens/tenant/prizeRange_widget.dart';
import 'package:tolet/screens/tenant/propertyfacilities.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedPropertyType = 'House';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyderabad'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertyTypeSection(),
              SizedBox(height: 16),
              PriceRangeWidget(),
              SizedBox(height: 16),
              PropertyFacilities(),
              SizedBox(height: 30),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildActionButtons(),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Property Type Section
  Widget _buildPropertyTypeSection() {
    final propertyTypes = ['Any', 'House', 'Hostel', 'Cabin', 'Flats', 'Shops'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
         Text('Property type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          height: 40,
          // Set a fixed height for the ListView
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
          _selectedPropertyType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
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
            fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  // Action Buttons

    Widget _buildActionButtons() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures the text and button are spaced
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        TextButton.icon(
          onPressed: () {
            // Handle reset action
          },
          icon: Icon(Icons.refresh),
          label: Text('Reset all'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle show results action
          },
          child: Text('Show results'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
      ],
    );
  }

}
