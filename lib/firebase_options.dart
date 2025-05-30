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
    apiKey: 'AIzaSyAlIKvheI5qVR2FLRAFF1W4kIdQGElH6Jw',
    appId: '1:77773812312:web:1481a863d2ee8aa8fa102d',
    messagingSenderId: '77773812312',
    projectId: 'eventos-culturales-f03c8',
    authDomain: 'eventos-culturales-f03c8.firebaseapp.com',
    storageBucket: 'eventos-culturales-f03c8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC76QlOVsGc5VwoRn3IoVAA4_6FWUW8RAA',
    appId: '1:77773812312:android:4eb04f546e1c3562fa102d',
    messagingSenderId: '77773812312',
    projectId: 'eventos-culturales-f03c8',
    storageBucket: 'eventos-culturales-f03c8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcnenTS-ABMA-p-aVL6PnFCczp-exWTt8',
    appId: '1:77773812312:ios:aa685af5f8753dccfa102d',
    messagingSenderId: '77773812312',
    projectId: 'eventos-culturales-f03c8',
    storageBucket: 'eventos-culturales-f03c8.firebasestorage.app',
    iosBundleId: 'com.example.eventosCulturales',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcnenTS-ABMA-p-aVL6PnFCczp-exWTt8',
    appId: '1:77773812312:ios:aa685af5f8753dccfa102d',
    messagingSenderId: '77773812312',
    projectId: 'eventos-culturales-f03c8',
    storageBucket: 'eventos-culturales-f03c8.firebasestorage.app',
    iosBundleId: 'com.example.eventosCulturales',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAlIKvheI5qVR2FLRAFF1W4kIdQGElH6Jw',
    appId: '1:77773812312:web:40c9947cfd6d5376fa102d',
    messagingSenderId: '77773812312',
    projectId: 'eventos-culturales-f03c8',
    authDomain: 'eventos-culturales-f03c8.firebaseapp.com',
    storageBucket: 'eventos-culturales-f03c8.firebasestorage.app',
  );
}
