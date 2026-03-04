// File generated manually from google-services.json and GoogleService-Info.plist.
// To regenerate, run `flutterfire configure`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQhh1oTXhTwgoaNzmDexjyPNoUtm0s2GY',
    appId: '1:741222572973:android:84f6f08f73b21904a73724',
    messagingSenderId: '741222572973',
    projectId: 'rundowntask',
    storageBucket: 'rundowntask.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUfIDBAVTjX0TIN5dbQN69Eg6xRYDQKqs',
    appId: '1:741222572973:ios:374c1468c8502539a73724',
    messagingSenderId: '741222572973',
    projectId: 'rundowntask',
    storageBucket: 'rundowntask.firebasestorage.app',
    iosBundleId: 'app.rundown.task',
    iosClientId: '741222572973-hraqhgvbu4j444164gukosarvavq9pgt.apps.googleusercontent.com',
  );
}
