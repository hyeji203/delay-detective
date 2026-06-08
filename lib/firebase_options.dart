// 이 파일은 flutterfire configure 명령으로 자동 생성됩니다.
// 현재는 플레이스홀더 — 실제 Firebase 연결을 위해 아래 명령을 실행하세요:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'Firebase 미설정: flutterfire configure를 실행하세요.',
        );
    }
  }

  // flutterfire configure 실행 후 아래 값들이 실제 프로젝트 값으로 교체됩니다.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_VALUE',
    appId: 'REPLACE_WITH_REAL_VALUE',
    messagingSenderId: 'REPLACE_WITH_REAL_VALUE',
    projectId: 'REPLACE_WITH_REAL_VALUE',
    storageBucket: 'REPLACE_WITH_REAL_VALUE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_VALUE',
    appId: 'REPLACE_WITH_REAL_VALUE',
    messagingSenderId: 'REPLACE_WITH_REAL_VALUE',
    projectId: 'REPLACE_WITH_REAL_VALUE',
    storageBucket: 'REPLACE_WITH_REAL_VALUE',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_VALUE',
    appId: 'REPLACE_WITH_REAL_VALUE',
    messagingSenderId: 'REPLACE_WITH_REAL_VALUE',
    projectId: 'REPLACE_WITH_REAL_VALUE',
    storageBucket: 'REPLACE_WITH_REAL_VALUE',
    iosBundleId: 'REPLACE_WITH_REAL_VALUE',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_VALUE',
    appId: 'REPLACE_WITH_REAL_VALUE',
    messagingSenderId: 'REPLACE_WITH_REAL_VALUE',
    projectId: 'REPLACE_WITH_REAL_VALUE',
    storageBucket: 'REPLACE_WITH_REAL_VALUE',
  );
}
