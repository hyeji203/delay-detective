import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/profile_button.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final activeTasks = provider.activeTasks;
    final completedTasks = provider.completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('할일'),
        actions: const [ProfileButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(height: 1, color: const Color(0xFFEEEEF5)),
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF3F51B5),
                unselectedLabelColor: const Color(0xFF9E9EAE),
                indicatorColor: const Color(0xFF3F51B5),
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: [
                  Tab(
                    text: activeTasks.isNotEmpty
                        ? '진행중 (${activeTasks.length})'
                        : '진행중',
                  ),
                  Tab(
                    text: completedTasks.isNotEmpty
                        ? '완료 (${completedTasks.length})'
                        : '완료',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TaskListView(
            tasks: activeTasks,
            emptyMessage: '진행중인 할일이 없어요 👏',
            emptySubMessage: '새 할일을 추가해보세요',
          ),
          _TaskListView(
            tasks: completedTasks,
            emptyMessage: '완료한 할일이 없어요',
            emptySubMessage: '할일을 완료하면 여기에 쌓여요',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        icon: const Icon(Icons.add),
        label: const Text('할 일 추가'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final String emptyMessage;
  final String emptySubMessage;

  const _TaskListView({
    required this.tasks,
    required this.emptyMessage,
    required this.emptySubMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              emptySubMessage,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9E9EAE),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) => TaskCard(
        task: tasks[i],
        isDelayed: tasks[i].isDelayed,
      ),
    );
  }
}
