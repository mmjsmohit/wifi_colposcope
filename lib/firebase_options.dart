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
    apiKey: 'AIzaSyDMnCTDXQhvxqeCx0MKNzLkn8KFpCnlGqU',
    appId: '1:196693211418:web:ad58c8ffd2ee62811d54a3',
    messagingSenderId: '196693211418',
    projectId: 'wifi-colposcope-344d7',
    authDomain: 'wifi-colposcope-344d7.firebaseapp.com',
    storageBucket: 'wifi-colposcope-344d7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkligXSs0CgPqo4g233fZHh6zz2Mkb3nY',
    appId: '1:196693211418:android:e58c423a46db154d1d54a3',
    messagingSenderId: '196693211418',
    projectId: 'wifi-colposcope-344d7',
    storageBucket: 'wifi-colposcope-344d7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrccDRpBka-2mC16YcJ0iRYaBNcKk50Uo',
    appId: '1:196693211418:ios:2d7a7cf8360d90981d54a3',
    messagingSenderId: '196693211418',
    projectId: 'wifi-colposcope-344d7',
    storageBucket: 'wifi-colposcope-344d7.appspot.com',
    iosClientId: '196693211418-b4v352onn1milu9n98p558jti0olnbbq.apps.googleusercontent.com',
    iosBundleId: 'com.example.wifiColposcope',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrccDRpBka-2mC16YcJ0iRYaBNcKk50Uo',
    appId: '1:196693211418:ios:2d7a7cf8360d90981d54a3',
    messagingSenderId: '196693211418',
    projectId: 'wifi-colposcope-344d7',
    storageBucket: 'wifi-colposcope-344d7.appspot.com',
    iosClientId: '196693211418-b4v352onn1milu9n98p558jti0olnbbq.apps.googleusercontent.com',
    iosBundleId: 'com.example.wifiColposcope',
  );
}