import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/chat_screen.dart';
import 'package:tolet/screens/tenant/favorite_property.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/tenant/see_all_properties.dart';
import 'package:tolet/screens/tenant/tenant_chatscreen.dart';
//import 'package:tolet/screens/tenant/tenant_finder.dart';
import 'package:tolet/screens/tenant/user_profile.dart';
import 'package:tolet/widgets/constcolor.dart';
class tenantDashboard extends StatefulWidget {
  @override
  _tenantDashboardState createState() => _tenantDashboardState();
}

class _tenantDashboardState extends State<tenantDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HometenantScreen(),
    SeeAllProperties(),
    TenantChatScreen(),
    FavoriteProperty(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if (_currentIndex == 0) {
        // If on the Home screen, allow the app to be closed
        return true;
      } else {
        // Navigate back to the Home screen
        setState(() {
          _currentIndex = 0;
        });
        return false;
      }
    },
    child:Scaffold(
        body: _screens[_currentIndex], // Display the selected screen
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff192747),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex, // Current index for selected tab
        onTap: _onTabTapped, // Update selected index
        items:<BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/homeblue.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/home1.png',
            height: 24,
            width: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activerequest.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/request.png',
            height: 24,
            width: 24,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activechat.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/chat.png',
            height: 24,
            width: 24,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/saved.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/saved.png',
            height: 24,
            width: 24,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            'assets/icons/activeProfile.png',
            height: 24,
            width: 24,
          ),
          icon: Image.asset(
            'assets/icons/profile.png',
            height: 24,
            width: 24,
          ),
          label: 'Profile',
        ),
        ],
        ),
    ),
    );
  }
}