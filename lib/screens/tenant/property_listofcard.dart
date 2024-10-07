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
}
