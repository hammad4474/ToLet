import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/auth/login_screen.dart';
import 'package:tolet/onboarding_screen.dart';
import 'package:tolet/screens/owner/ownerdashboard.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

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

    if (isFirstTime) {
      setState(() {
        _initialScreen = OnBoarding();
      });
      prefs.setBool('isFirstTime',
          false); // Set as not first-time after showing onboarding
    } else if (isLoggedIn && userType != null) {
      // Navigate based on the stored userType
      if (userType == 'Tenant') {
        setState(() {
          _initialScreen = tenantDashboard();
        });
      } else if (userType == 'Landlord') {
        setState(() {
          _initialScreen = ownerDashboard();
        });
      } else {
        setState(() {
          _initialScreen = LoginScreen();
        });
      }
    } else {
      setState(() {
        _initialScreen = LoginScreen();
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
