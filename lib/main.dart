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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(color: Colors.white),
        primaryColor: const Color(0xff1c2746),
      ),
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late Widget _initialScreen;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isFirstTime = prefs.getBool('isFirstTime');
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userType = prefs.getString('userType');

    if (isFirstTime == null || isFirstTime == true) {
      // Show onboarding screen for the first launch
      _initialScreen = OnBoarding();
      await prefs.setBool('isFirstTime', false);
    } else if (isLoggedIn && userType != null) {
      // Direct user to their dashboard if logged in
      _initialScreen =
          userType == 'Tenant' ? tenantDashboard() : ownerDashboard();
    } else {
      // If not logged in, show the login screen
      _initialScreen = LoginScreen();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _initialScreen;
  }
}
