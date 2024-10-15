import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'screens/tenant/filter_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(color: Colors.white),
          primaryColor: Colors.white),
      home: WelcomeScreen(),
    );
  }
}
