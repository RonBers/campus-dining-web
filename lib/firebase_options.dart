// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['APIKEY_WEB'] ?? '',
    appId: '1:813218655539:web:3b0c1f85b4d21df0a5a246',
    messagingSenderId: '813218655539',
    projectId: 't2024cs3-campusdiningapp-ac2a3',
    authDomain: 't2024cs3-campusdiningapp-ac2a3.firebaseapp.com',
    storageBucket: 't2024cs3-campusdiningapp-ac2a3.firebasestorage.app',
    measurementId: 'G-X7TKLM5KHT',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['APIKEY_ANDROID'] ?? '',
    appId: '1:813218655539:android:ac953fccbff501c9a5a246',
    messagingSenderId: '813218655539',
    projectId: 't2024cs3-campusdiningapp-ac2a3',
    storageBucket: 't2024cs3-campusdiningapp-ac2a3.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['APIKEY_IOS'] ?? '',
    appId: '1:813218655539:ios:0bd5a883e93ca6a4a5a246',
    messagingSenderId: '813218655539',
    projectId: 't2024cs3-campusdiningapp-ac2a3',
    storageBucket: 't2024cs3-campusdiningapp-ac2a3.firebasestorage.app',
    androidClientId:
        '813218655539-26l70gh5iv3ebe5v1qf0890rdg6c40gq.apps.googleusercontent.com',
    iosClientId:
        '813218655539-oj6lpdbncrrqp76dng93krnjdbfq9fte.apps.googleusercontent.com',
    iosBundleId: 'com.example.campusDiningWeb',
  );
}
