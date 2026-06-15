import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'application/task_provider.dart';
import 'application/ai_provider.dart';
import 'application/sync_provider.dart';
import 'application/auth_provider.dart';
import 'data/local/hive_service.dart';
import 'data/remote/ai_service.dart';
import 'data/remote/auth_service.dart';
import 'data/remote/firestore_service.dart';
import 'data/sync/sync_service.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/add_task_screen.dart';
import 'presentation/screens/interview_screen.dart';
import 'presentation/screens/analysis_result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final hive = HiveService();
  await hive.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}

  final authService = AuthService();
  final firestore = FirestoreService();
  final aiService = AIService();
  final syncService = SyncService(hive: hive, firestore: firestore);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => AIProvider(aiService: aiService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (ctx) => TaskProvider(
            hive: hive,
            firestore: firestore,
            uid: ctx.read<AuthProvider>().uid,
          ),
          update: (ctx, auth, prev) {
            if (prev?.rawUid == auth.uid) return prev!;
            return TaskProvider(hive: hive, firestore: firestore, uid: auth.uid);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, SyncProvider>(
          create: (ctx) => SyncProvider(
            syncService: syncService,
            uid: ctx.read<AuthProvider>().uid ?? 'offline',
          ),
          update: (ctx, auth, prev) {
            final newUid = auth.uid ?? 'offline';
            if (prev?.uid == newUid) return prev!;
            return SyncProvider(syncService: syncService, uid: newUid);
          },
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const _AuthGate(),
      routes: {
        '/add-task': (_) => const AddTaskScreen(),
        '/interview': (_) => const InterviewScreen(),
        '/result': (_) => const AnalysisResultScreen(),
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) return const SplashScreen();
    if (auth.isLoggedIn) return const MainScreen();
    return const LoginScreen();
  }
}
