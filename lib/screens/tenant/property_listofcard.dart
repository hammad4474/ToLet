import 'package:flutter/material.dart';

class Property {
  final String title;
  final String city;
  final String price;
  final bool isVerified;
  final String rooms;
  final String area;
  final String imageUrl;

  Property({
    required this.title,
    required this.city,
    required this.price,
    required this.isVerified,
    required this.rooms,
    required this.area,
    required this.imageUrl,
  });

  // Method to convert from Map to Property
  factory Property.fromMap(Map<String, dynamic> data) {
    return Property(
      title: data['title'],
      city: data['city'],
      price: data['price'],
      isVerified: data['isVerified'],
      rooms: data['rooms'],
      area: data['area'],
      imageUrl: data['imageUrl'],
    );
  }
}
// class Property {
//   final String title;
//   final String city;
//   final String price;
//   final bool isVerified;
//   final String rooms;
//   final String area;
//   final String imageUrl;

//   Property({
//     required this.title,
//     required this.city,
//     required this.price,
//     required this.isVerified,
//     required this.rooms,
//     required this.area,
//     required this.imageUrl,
//   });
// }
