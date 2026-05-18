import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../application/sync_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/sync_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 태스크 불러오기
    Future.microtask(
      () => context.read<TaskProvider>().loadTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delay Detective'),
      ),
      body: Column(
        children: [
          // 동기화 상태 배너
          const SyncBanner(),

          // 태스크 목록
          Expanded(
            child: ListView(
              children: [
                // 지연 태스크 (상단 고정)
                if (taskProvider.delayedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '미루고 있는 태스크',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ...taskProvider.delayedTasks.map(
                    (task) => TaskCard(task: task, isDelayed: true),
                  ),
                ],

                // 일반 태스크
                if (taskProvider.normalTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('태스크'),
                  ),
                  ...taskProvider.normalTasks.map(
                    (task) => TaskCard(task: task, isDelayed: false),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
