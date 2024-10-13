import 'package:flutter/material.dart';

class PropertyFacilities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Property facilities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle "See more" action
                },
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10.0, // Horizontal space between chips
            runSpacing: 10.0, // Vertical space between rows
            children: [
              FacilityChip(label: 'Furnished', active: false),
              FacilityChip(label: 'WiFi', active: true),
              FacilityChip(label: 'Kitchen', active: false),
              FacilityChip(label: 'Self Check-in', active: false),
              FacilityChip(label: 'Free parking', active: false),
              FacilityChip(label: 'Air conditioner', active: true),
              FacilityChip(label: 'Security', active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class FacilityChip extends StatelessWidget {
  final String label;
  final bool active;

  FacilityChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
