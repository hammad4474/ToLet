import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpdatePropertyScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const UpdatePropertyScreen({Key? key, required this.property})
      : super(key: key);

  @override
  _UpdatePropertyScreenState createState() => _UpdatePropertyScreenState();
}

class _UpdatePropertyScreenState extends State<UpdatePropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to hold the updated property data
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late TextEditingController _areaController;

  String? _bhkValue; // BHK value selected by the user

  bool _isLoading = false; // Loader state

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the existing property data
    _titleController =
        TextEditingController(text: widget.property['propertyTitle']);
    _priceController = TextEditingController(text: widget.property['price']);
    _locationController =
        TextEditingController(text: widget.property['location']);
    _areaController = TextEditingController(text: widget.property['area']);
    _bhkValue = widget.property['bhk'].replaceAll(' ', '');
// e.g., "2 BHK" becomes "2BHK"
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loader
      });

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('properties')
            .doc(widget.property['id'])
            .update({
          'propertyTitle': _titleController.text,
          'price': _priceController.text,
          'location': _locationController.text,
          'area': _areaController.text,
          'bhk': _bhkValue, // Update BHK value
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property updated successfully')),
        );

        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating property: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loader after process
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Update Property'),
        backgroundColor: Color(0xff1a2847),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Property Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area (sq meters)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the area';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _bhkValue,
                decoration: InputDecoration(
                  labelText: 'BHK',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: const [
                  DropdownMenuItem(value: '1BHK', child: Text('1 BHK')),
                  DropdownMenuItem(value: '2BHK', child: Text('2 BHK')),
                  DropdownMenuItem(value: '3BHK', child: Text('3 BHK')),
                  DropdownMenuItem(value: '4BHK', child: Text('4 BHK')),
                ],
                onChanged: (value) {
                  setState(() {
                    _bhkValue = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the number of BHKs';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _updateProperty, // Disable button when loading
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xff1a2847),
                  disabledForegroundColor: Color(0xff1a2847).withOpacity(0.38),
                  disabledBackgroundColor: Color(0xff1a2847).withOpacity(0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50)
                    : Text(
                        'Update Property',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
