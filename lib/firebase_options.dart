// File generated temporarily until `flutterfire configure` is run with the real Firebase project.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Temporary [FirebaseOptions] for running the app locally before linking Firebase.
/// Run `flutterfire configure` once signed in to replace this file with real credentials.
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
    apiKey: 'TEMP_API_KEY',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'lavelle-home-temp',
    authDomain: 'lavelle-home-temp.firebaseapp.com',
    storageBucket: 'lavelle-home-temp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TEMP_API_KEY',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'lavelle-home-temp',
    storageBucket: 'lavelle-home-temp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TEMP_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'lavelle-home-temp',
    storageBucket: 'lavelle-home-temp.firebasestorage.app',
    iosBundleId: 'com.lavelle.home',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TEMP_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'lavelle-home-temp',
    storageBucket: 'lavelle-home-temp.firebasestorage.app',
    iosBundleId: 'com.lavelle.home',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'TEMP_API_KEY',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'lavelle-home-temp',
    authDomain: 'lavelle-home-temp.firebaseapp.com',
    storageBucket: 'lavelle-home-temp.firebasestorage.app',
  );
}
