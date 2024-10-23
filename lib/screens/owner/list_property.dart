// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:tolet/screens/owner/bottom_navigation.dart';
import 'package:tolet/screens/tenant/property_listofcard.dart';

class ListPropertyScreen extends StatefulWidget {
  const ListPropertyScreen({Key? key}) : super(key: key);

  @override
  _ListPropertyScreenState createState() => _ListPropertyScreenState();
}

class _ListPropertyScreenState extends State<ListPropertyScreen> {
  int _selectedIndex = 2;

  String selectedBHK = '';
  bool isChecked = false;
  String propertyTitle = '';
  String price = '';
  String? owner = '';
  bool isLoading = false;

  File? _selectedImage;
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images =
        await _picker.pickMultiImage(); // Updated to pick multiple images

    if (images != null && images.isNotEmpty) {
      bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Image Selection'),
            content: SizedBox(
              height: 200,
              width: 400,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(File(images[index].path)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          _selectedImages = images.map((image) => File(image.path)).toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Images confirmed and selected.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selection canceled.')),
        );
      }
    }
  }

  Set<String> selectedFacilities = {};

  void _onSelect(String bhk) {
    setState(() {
      selectedBHK = bhk;
    });
  }

  void toggleSelection(String facility) {
    setState(() {
      if (selectedFacilities.contains(facility)) {
        selectedFacilities.remove(facility);
      } else {
        selectedFacilities.add(facility);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> savePropertyData() async {
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    if (propertyTitle.isEmpty ||
        price.isEmpty ||
        selectedBHK.isEmpty ||
        selectedFacilities.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields and select images')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      owner = user.toString();
      if (user != null) {
        List<String> downloadURLs = [];

        for (File image in _selectedImages) {
          String fileName =
              'properties/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${_selectedImages.indexOf(image)}.png';
          Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(fileName);

          TaskSnapshot uploadTask = await firebaseStorageRef.putFile(image);
          String downloadURL = await uploadTask.ref.getDownloadURL();
          downloadURLs.add(downloadURL);
        }

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            owner = userDoc['firstname'] ?? 'User';
          });
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('properties')
            .add({
          'propertyTitle': propertyTitle,
          'bhk': selectedBHK,
          'facilities': selectedFacilities.toList(),
          'price': price,
          'imageURLs': downloadURLs, // Saving multiple image URLs
          'createdAt': FieldValue.serverTimestamp(),
          'owner': owner,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Property details and images saved successfully!')),
        );

        await FirebaseFirestore.instance.collection('propertiesAll').add({
          'propertyTitle': propertyTitle,
          'bhk': selectedBHK,
          'facilities': selectedFacilities.toList(),
          'price': price,
          'imageURLs': downloadURLs, // Saving multiple image URLs
          'createdAt': FieldValue.serverTimestamp(),
          'owner': owner,
        });

        setState(() {
          propertyTitle = '';
          price = '';
          selectedBHK = '';
          selectedFacilities.clear();
          _selectedImages.clear();
        });

        print('PropertyAll added successfully');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving property: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'List new property',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'List in the market where renters are waiting!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: TextEditingController(text: propertyTitle),
                    onChanged: (value) => propertyTitle = value,
                    decoration: InputDecoration(
                      labelText: 'Property title',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor:
                          Color(0xfff2f3f3), // Set the grey background color
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(3.0), // Adjust the curve
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              Colors.transparent, // Remove border when inactive
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                // Location (map placeholder)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/images/Location.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // BHK Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _onSelect('1 BHK'),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              13), // Match the Container's radius
                        ),
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                              color: selectedBHK == '1 BHK'
                                  ? Color(0xffe3e3e7)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(child: Text('1 BHK')),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onSelect('2 BHK'),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              13), // Match the Container's radius
                        ),
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                              color: selectedBHK == '2 BHK'
                                  ? Color(0xffe3e3e7)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(child: Text('2 BHK')),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onSelect('3 BHK'),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              13), // Match the Container's radius
                        ),
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                              color: selectedBHK == '3 BHK'
                                  ? Color(0xffe3e3e7)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(child: Text('3 BHK')),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onSelect('4 BHK'),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              13), // Match the Container's radius
                        ),
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                              color: selectedBHK == '4 BHK'
                                  ? Color(0xffe3e3e7)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(child: Text('4 BHK')),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                // Rent input
                SizedBox(
                  width: double.infinity, // Take the full width of the screen
                  child: TextField(
                    controller: TextEditingController(text: price),
                    onChanged: (value) {
                      price = value;
                    },
                    decoration: InputDecoration(
                      labelText: '600/ per month',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor:
                          Color(0xfff2f3f3), // Set the grey background color
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(3.0), // Adjust the curve
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              Colors.transparent, // Remove border when inactive
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // Facilities Grid
                Text(
                  'Facilities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    facilities(
                      image: 'assets/icons/CAR.png',
                      text: 'Car Parking',
                      isSelected: selectedFacilities.contains('Car Parking'),
                      onTap: () => toggleSelection('Car Parking'),
                    ),
                    facilities(
                      image: 'assets/icons/Vector (3).png',
                      text: 'Furnished',
                      isSelected: selectedFacilities.contains('Furnished'),
                      onTap: () => toggleSelection('Furnished'),
                    ),
                    facilities(
                      image: 'assets/icons/GYM.png',
                      text: 'Gym Fit',
                      isSelected: selectedFacilities.contains('Gym Fit'),
                      onTap: () => toggleSelection('Gym Fit'),
                    ),
                    facilities(
                      image: 'assets/icons/FOOD.png',
                      text: 'Kitchen',
                      isSelected: selectedFacilities.contains('Kitchen'),
                      onTap: () => toggleSelection('Kitchen'),
                    ),
                    facilities(
                      image: 'assets/icons/WIFI.png',
                      text: 'WI-fi',
                      isSelected: selectedFacilities.contains('WI-fi'),
                      onTap: () => toggleSelection('WI-fi'),
                    ),
                    facilities(
                      image: 'assets/icons/PET.png',
                      text: 'Pet center',
                      isSelected: selectedFacilities.contains('Pet center'),
                      onTap: () => toggleSelection('Pet center'),
                    ),
                    facilities(
                      image: 'assets/icons/RUN.png',
                      text: 'Sports',
                      isSelected: selectedFacilities.contains('Sports'),
                      onTap: () => toggleSelection('Sports'),
                    ),
                    facilities(
                      image: 'assets/icons/LAUNDRY.png',
                      text: 'Laundry',
                      isSelected: selectedFacilities.contains('Laundry'),
                      onTap: () => toggleSelection('Laundry'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Upload photos
                GestureDetector(
                  onTap: () {
                    _pickImages();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isLoading
                        ? LoadingAnimationWidget.waveDots(
                            color: Colors.black, size: 50)
                        : Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Align to the left
                            children: [
                              // "Photos" label above the camera icon
                              Text(
                                'Photos',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/upload.png'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  // "Upload Property Pictures" on the left
                                  Text('Upload Property Pictures'),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 20),
                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      checkColor: Colors.red,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          // Update the checkbox value
                        });
                      },
                    ),
                    Expanded(
                      child: Text('I agree to the terms and conditions'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      savePropertyData();
                      print('Property Title: $propertyTitle');
                      print('Price: $price');
                      print('Selected BHK: $selectedBHK');
                      print('Selected Facilities: $selectedFacilities');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2e8d1a),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Slightly square edges, adjust value as needed
                      ),
                    ),
                    child: Text('SUBMIT',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}

class facilities extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  String text;
  String image;
  facilities({
    Key? key,
    required this.text,
    required this.image,
    required this.isSelected, // Assign isSelected to constructor
    required this.onTap, // Correctly assign onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xffe3e3e7) : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
              ),
              SizedBox(
                height: 5,
              ),
              Text(text.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
