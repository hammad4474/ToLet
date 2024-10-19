import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/owner/dashboard.dart';
import 'package:tolet/screens/owner/home_screen.dart';
import 'package:tolet/screens/tenant/SearchPropertyScreen.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'screens/tenant/filter_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: AppBarTheme(color: Colors.white),
        primaryColor: Color(0xff1c2746),
      ),
      home: WelcomeScreen(),
    );
  }
}
