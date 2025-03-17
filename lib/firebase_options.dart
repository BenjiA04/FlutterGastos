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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD4_yEgp_--N_2KMBjB4n6MUy6X76uDWko',
    appId: '1:510376192927:web:462bfbb68ce274c59c2baa',
    messagingSenderId: '510376192927',
    projectId: 'fluttergastos-fbc08',
    authDomain: 'fluttergastos-fbc08.firebaseapp.com',
    storageBucket: 'fluttergastos-fbc08.firebasestorage.app',
    measurementId: 'G-FQZDCVP84T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ0URQWdCwKBr4IutGmk4rjlMcks8TfpA',
    appId: '1:510376192927:android:d9d2921310f9e09b9c2baa',
    messagingSenderId: '510376192927',
    projectId: 'fluttergastos-fbc08',
    storageBucket: 'fluttergastos-fbc08.firebasestorage.app',
  );
}
