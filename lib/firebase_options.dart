// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDd4RYn2WmtlVy-Lkf5m8N1_VkPbPxfa_4',
    appId: '1:534362826648:web:4f90cb02b42842e5c42ded',
    messagingSenderId: '534362826648',
    projectId: 'activity-20',
    authDomain: 'activity-20.firebaseapp.com',
    storageBucket: 'activity-20.appspot.com',
    measurementId: 'G-DVBY9PXHHT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeV11e2t7CYU3m5Z4flIPN-APExOZDbuM',
    appId: '1:534362826648:android:1d783671f48f884cc42ded',
    messagingSenderId: '534362826648',
    projectId: 'activity-20',
    storageBucket: 'activity-20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNgzF-_pIGTXi9-N4axJfAlN6gpgoVJzI',
    appId: '1:534362826648:ios:2a23ed714b28c8d7c42ded',
    messagingSenderId: '534362826648',
    projectId: 'activity-20',
    storageBucket: 'activity-20.appspot.com',
    iosBundleId: 'com.example.flutterApplicationProjet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNgzF-_pIGTXi9-N4axJfAlN6gpgoVJzI',
    appId: '1:534362826648:ios:57ff4efcff7f1534c42ded',
    messagingSenderId: '534362826648',
    projectId: 'activity-20',
    storageBucket: 'activity-20.appspot.com',
    iosBundleId: 'com.example.flutterApplicationProjet.RunnerTests',
  );
}
