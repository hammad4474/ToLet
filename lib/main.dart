import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/auth/login_screen.dart';
import 'package:tolet/onboarding_screen.dart';
import 'package:tolet/screens/owner/ownerdashboard.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'firebase_options.dart';



// Future<void> backgroundHandler(RemoteMessage message) async {
//   String? title = message.notification!.title;
//   String? body = message.notification!.body;
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 123,
//       channelKey: 'call-key',
//       color: Colors.white,
//       title: title,
//       body: body,
//       category: NotificationCategory.Call,
//       wakeUpScreen: true,
//       autoDismissible: false,
//       fullScreenIntent: true,
//       backgroundColor: Colors.orange,
//     ),
//     actionButtons: [
//       NotificationActionButton(
//           key: 'Accept',
//           label: 'Accept Call',
//           color: Colors.green,
//           autoDismissible: true),
//       NotificationActionButton(
//           key: 'Reject',
//           label: 'Reject Call',
//           color: Colors.red,
//           autoDismissible: false),
//     ],
//   );
// }

void main() async {
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //     channelKey: 'call-key',
  //     channelName: '',
  //     channelDescription: '',
  //     defaultColor: Colors.redAccent,
  //     importance: NotificationImportance.Max,
  //     channelShowBadge: true,
  //     locked: true,
  //     defaultRingtoneType: DefaultRingtoneType.Ringtone,
  //   )
  // ]);
  // FirebaseMessaging.onBackgroundMessage(
  //     backgroundHandler as BackgroundMessageHandler);
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
      debugShowCheckedModeBanner: false,
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
