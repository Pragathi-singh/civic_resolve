import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCV7PsFeZfySYbJjReJwHA7otsrTQKrjcI',
    appId: '1:366878967278:web:188fc97f4caca3be6e7aff',
    messagingSenderId: '366878967278',
    projectId: 'civic-resolve-ab3bc',
    authDomain: 'civic-resolve-ab3bc.firebaseapp.com',
    storageBucket: 'civic-resolve-ab3bc.firebasestorage.app',
    measurementId: 'G-LQWG76D4NH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: '366878967278',
    projectId: 'civic-resolve-ab3bc',
    storageBucket: 'civic-resolve-ab3bc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '366878967278',
    projectId: 'civic-resolve-ab3bc',
    storageBucket: 'civic-resolve-ab3bc.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: '366878967278',
    projectId: 'civic-resolve-ab3bc',
    storageBucket: 'civic-resolve-ab3bc.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: '366878967278',
    projectId: 'civic-resolve-ab3bc',
    storageBucket: 'civic-resolve-ab3bc.firebasestorage.app',
  );
}
