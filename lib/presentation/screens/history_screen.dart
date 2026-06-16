import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';
import '../widgets/profile_button.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasksWithAnalysis;

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 히스토리'),
        actions: const [ProfileButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: tasks.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _HistoryCard(task: tasks[i]),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔍', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(
            '아직 분석 기록이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '지연된 태스크를 AI로 분석해보세요',
            style: TextStyle(fontSize: 14, color: Color(0xFF9E9EAE)),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Task task;
  const _HistoryCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final analysis = task.analysis!;
    final completedCount = task.subtasks.where((s) => s.isDone).length;
    final totalCount = task.subtasks.length;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/result',
        arguments: {'task': task, 'analysis': analysis},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                Text(
                  _formatDate(analysis.analyzedAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9EAE),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              analysis.causeSummary,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5A7A),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (totalCount > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: completedCount / totalCount,
                        backgroundColor: const Color(0xFFEEEEF5),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF3F51B5),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$completedCount/$totalCount 완료',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3F51B5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
