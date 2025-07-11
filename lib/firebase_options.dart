// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQemD0_fUsgTPMs83jT2lMuypx0Ujw_Ro',
    appId: '1:381700652858:web:cc92f1c42ac11f8ac95a03',
    messagingSenderId: '381700652858',
    projectId: 'tolet-b666d',
    authDomain: 'tolet-b666d.firebaseapp.com',
    storageBucket: 'tolet-b666d.appspot.com',
    measurementId: 'G-VTHL14LVP5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAh-0n5N5hPhJZmY7DTN0BSNie2Mqsdy50',
    appId: '1:381700652858:android:8dd87608665e750dc95a03',
    messagingSenderId: '381700652858',
    projectId: 'tolet-b666d',
    storageBucket: 'tolet-b666d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZhG5OtwJT-tmfbf3E0qxB3fhYDc0l61M',
    appId: '1:381700652858:ios:eb9f107e430f2844c95a03',
    messagingSenderId: '381700652858',
    projectId: 'tolet-b666d',
    storageBucket: 'tolet-b666d.appspot.com',
    iosBundleId: 'com.example.tolet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZhG5OtwJT-tmfbf3E0qxB3fhYDc0l61M',
    appId: '1:381700652858:ios:eb9f107e430f2844c95a03',
    messagingSenderId: '381700652858',
    projectId: 'tolet-b666d',
    storageBucket: 'tolet-b666d.appspot.com',
    iosBundleId: 'com.example.tolet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQemD0_fUsgTPMs83jT2lMuypx0Ujw_Ro',
    appId: '1:381700652858:web:75e4ffea08bcb823c95a03',
    messagingSenderId: '381700652858',
    projectId: 'tolet-b666d',
    authDomain: 'tolet-b666d.firebaseapp.com',
    storageBucket: 'tolet-b666d.appspot.com',
    measurementId: 'G-9ZXCS13329',
  );

}