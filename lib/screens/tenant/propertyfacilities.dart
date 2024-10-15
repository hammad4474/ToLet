import 'package:flutter/material.dart';

class PropertyFacilities extends StatefulWidget {
  @override
  _PropertyFacilitiesState createState() => _PropertyFacilitiesState();
}

class _PropertyFacilitiesState extends State<PropertyFacilities> {
  // List of facility states (active or not)
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
          Container(
            child: Column(children: <Widget>[
             Expanded (
              flex:3,
              child : Row(
                children: facilities.keys.map((facility) {
                   return GestureDetector(
                     onTap: () {
                       setState(() {
                         // Toggle the active state of the selected facility
                         facilities[facility] = !facilities[facility]!;
                       });
                     },
                     child: FacilityChip(
                       label: facility,
                       active: facilities[facility]!,
                     ),
                   );
                 }).toList(),
              ),),

            ],
            ),

          ),
          // GridView.count(
          //   crossAxisCount: 3, // Number of columns in the grid
          //   shrinkWrap: true,  // Ensures GridView doesn't expand infinitely
          //   crossAxisSpacing: 10.0, // Horizontal spacing between grid items
          //   mainAxisSpacing: 10.0,  // Vertical spacing between grid items
          //   children: facilities.keys.map((facility) {
          //     return GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           // Toggle the active state of the selected facility
          //           facilities[facility] = !facilities[facility]!;
          //         });
          //       },
          //       child: FacilityChip(
          //         label: facility,
          //         active: facilities[facility]!,
          //       ),
          //     );
          //   }).toList(),
          // ),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding controls the internal spacing
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        gradient: active
            ? LinearGradient(
          colors: [Colors.lightBlue, Colors.blue],
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
