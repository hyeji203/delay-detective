import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'application/task_provider.dart';
import 'application/ai_provider.dart';
import 'application/sync_provider.dart';
import 'data/local/hive_service.dart';
import 'data/remote/ai_service.dart';
import 'data/remote/firestore_service.dart';
import 'data/sync/sync_service.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/add_task_screen.dart';
import 'presentation/screens/interview_screen.dart';
import 'presentation/screens/analysis_result_screen.dart';

Future<String> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
    return auth.currentUser!.uid;
  } catch (_) {
    // Firebase 미설정 또는 네트워크 없음 → 오프라인 전용 모드
    return 'offline-user-${DateTime.now().millisecondsSinceEpoch}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final uid = await _initFirebase();

  final hive = HiveService();
  await hive.init();

  final firestore = FirestoreService();
  final aiService = AIService();
  final syncService = SyncService(hive: hive, firestore: firestore);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(hive: hive, firestore: firestore, uid: uid),
        ),
        ChangeNotifierProvider(
          create: (_) => AIProvider(aiService: aiService),
        ),
        ChangeNotifierProvider(
          create: (_) => SyncProvider(syncService: syncService, uid: uid),
        ),
      ],
      child: const DelayDetectiveApp(),
    ),
  );
}

class DelayDetectiveApp extends StatelessWidget {
  const DelayDetectiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delay Detective',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/add-task': (_) => const AddTaskScreen(),
        '/interview': (_) => const InterviewScreen(),
        '/result': (_) => const AnalysisResultScreen(),
      },
    );
  }
}
