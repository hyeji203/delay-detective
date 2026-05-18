import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:delay_detective/main.dart';
import 'package:delay_detective/application/task_provider.dart';
import 'package:delay_detective/application/ai_provider.dart';
import 'package:delay_detective/application/sync_provider.dart';
import 'package:delay_detective/data/local/hive_service.dart';
import 'package:delay_detective/data/remote/ai_service.dart';
import 'package:delay_detective/data/remote/firestore_service.dart';
import 'package:delay_detective/data/sync/sync_service.dart';

void main() {
  testWidgets('App smoke test — builds without crashing', (WidgetTester tester) async {
    final hive = HiveService();
    final firestore = FirestoreService();
    final sync = SyncService(hive: hive, firestore: firestore);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider(hive: hive)),
          ChangeNotifierProvider(create: (_) => AIProvider(aiService: AIService())),
          ChangeNotifierProvider(create: (_) => SyncProvider(syncService: sync, uid: 'test')),
        ],
        child: const DelayDetectiveApp(),
      ),
    );

    expect(find.byType(DelayDetectiveApp), findsOneWidget);
  });
}
