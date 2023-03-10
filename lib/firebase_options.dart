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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtcw6u32Xjc5932cwR7CgjKWBs_Fxt-7Y',
    appId: '1:657431779818:android:7588636bc46069040dfa93',
    messagingSenderId: '657431779818',
    projectId: 'chat-stack-792bb',
    storageBucket: 'chat-stack-792bb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEFlllsAKyv9iSZj4TCzC83A_75DNp6pI',
    appId: '1:657431779818:ios:bf5b9f50a9e6ef890dfa93',
    messagingSenderId: '657431779818',
    projectId: 'chat-stack-792bb',
    storageBucket: 'chat-stack-792bb.appspot.com',
    androidClientId: '657431779818-vebe58fcq3g139putgs1hcnaree8n4ma.apps.googleusercontent.com',
    iosClientId: '657431779818-gir9onpv64mp7msb3h3hu6832814b359.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatStack',
  );
}
