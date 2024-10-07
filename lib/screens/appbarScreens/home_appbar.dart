import 'package:flutter/material.dart';

class home_appBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Required to set AppBar height

  home_appBar({Key? key}) : preferredSize = const Size.fromHeight(70.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable default back button
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      title: Row(
        children: [
          // Logo

          SizedBox(width: 10),
          Image.asset(
            'assets/images/logo.png', // Replace with your actual logo asset
            height: 90,
            width: 70,
          ),

          SizedBox(width: 10),

          // Search Bar with constraints and overflow handling
          Expanded(
            child: Container(

              height: 45,
              constraints: BoxConstraints(maxWidth: 500), // Limit maximum width of search bar
              decoration: BoxDecoration(
                color: Colors.grey[200],
                backgroundBlendMode: BlendMode.color,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search address, city, location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Tune Icon on the right side
          // Custom Icon Button
          IconButton(
            icon: Image.asset(
              'assets/icons/custum_tune_icon.png', // Replace with your actual custom icon asset
              height: 40,
              width: 40,
            ),
            onPressed: () {
              // Define what happens when you click the custom icon
            },
          ),
        ],
      ),
    );
  }
}
