import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final VoidCallback onTuneIconPressed;
  final VoidCallback onSearchBarTapped;

  HomeAppBar({
    Key? key,
    required this.onTuneIconPressed,
    required this.onSearchBarTapped,
  })  : preferredSize = const Size.fromHeight(70.0),
        super(key: key);

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

          // Search Bar with tap detection
          Expanded(
            child: GestureDetector(
              onTap: onSearchBarTapped, // Trigger callback when tapped
              child: Container(
                height: 45,
                constraints: BoxConstraints(
                    maxWidth: 500), // Limit max width of search bar
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Expanded(
                      child: Text(
                        'Search address, city, location',
                        style:
                            TextStyle(color: Colors.grey), // Placeholder style
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tune Icon on the right
          IconButton(
            icon: Image.asset(
              'assets/icons/custum_tune_icon.png', // Replace with your actual custom icon asset
              height: 40,
              width: 40,
            ),

            onPressed: onTuneIconPressed, // Use the callback passed from parent
          ),
        ],
      ),
    );
  }
}
