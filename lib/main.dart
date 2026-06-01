import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'application/task_provider.dart';
import 'application/ai_provider.dart';
import 'application/sync_provider.dart';
import 'data/local/hive_service.dart';
import 'data/remote/ai_service.dart';
import 'data/remote/firestore_service.dart';
import 'data/sync/sync_service.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/add_task_screen.dart';
import 'presentation/screens/interview_screen.dart';
import 'presentation/screens/analysis_result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // 구현 예정: Firebase 초기화 + 익명 로그인
  // await Firebase.initializeApp();
  // final uid = await _signInAnonymously();

  const uid = 'anonymous-placeholder'; // Firebase 연결 전 임시값

  final hive = HiveService();
  await hive.init();
  await hive.clearAll(); // 구 Map 형식 데이터 초기화 (1회성)

  final firestore = FirestoreService();
  final aiService = AIService();
  final syncService = SyncService(hive: hive, firestore: firestore);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(hive: hive),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/add-task': (_) => const AddTaskScreen(),
        '/interview': (_) => const InterviewScreen(),
        '/result': (_) => const AnalysisResultScreen(),
      },
    );
  }
}
