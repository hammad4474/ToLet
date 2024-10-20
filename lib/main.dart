import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/auth/login_screen.dart';
import 'package:tolet/screens/owner/home_screen.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  Widget _initialScreen = WelcomeScreen();

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userType = prefs.getString('userType');
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;



    if (isLoggedIn && userType != null) {
      // Navigate based on the stored userType
      if (userType == 'Tenant') {
        setState(() {
          _initialScreen = HometenantScreen();
        });
      } else if (userType == 'Landlord') {
        setState(() {
          _initialScreen = HomeScreen();
        });
      } else {
        // If userType is unknown, navigate to LoginScreen
        setState(() {
          _initialScreen = LoginScreen();
        });
      }
    } else {
      // If not logged in, show the WelcomeScreen

      setState(() {
        _initialScreen = isFirstTime ? WelcomeScreen() : LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: AppBarTheme(color: Colors.white),
        primaryColor: Color(0xff1c2746),
      ),
      home: _initialScreen,
    );
  }
}