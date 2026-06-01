import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';
import '../../domain/enums/task_status.dart';
import 'delayed_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDelayed;

  const TaskCard({super.key, required this.task, required this.isDelayed});

  Future<void> _markDelayed(BuildContext context) async {
    task.isDelayed = true;
    task.status = TaskStatus.delayed;
    await context.read<TaskProvider>().updateTask(task);
  }

  Future<void> _markDone(BuildContext context) async {
    task.status = TaskStatus.done;
    task.isDelayed = false;
    await context.read<TaskProvider>().updateTask(task);
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDelayed)
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('AI에게 물어보기'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/interview', arguments: task);
                },
              ),
            if (!isDelayed)
              ListTile(
                leading: const Icon(Icons.alarm, color: Colors.orange),
                title: const Text('미루고 있어요'),
                onTap: () {
                  Navigator.pop(context);
                  _markDelayed(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('완료했어요'),
              onTap: () {
                Navigator.pop(context);
                _markDone(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('삭제'),
              onTap: () {
                Navigator.pop(context);
                context.read<TaskProvider>().deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(task.title),
        subtitle: task.dueDate != null
            ? Text('마감: ${task.dueDate!.year}.${task.dueDate!.month}.${task.dueDate!.day}')
            : null,
        trailing: isDelayed
            ? GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/interview', arguments: task),
                child: const DelayedBadge(),
              )
            : null,
        onTap: () => _showOptions(context),
        onLongPress: () => _showOptions(context),
      ),
    );
  }
}
