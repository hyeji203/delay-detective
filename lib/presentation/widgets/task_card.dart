import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import 'delayed_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDelayed;

  const TaskCard({super.key, required this.task, required this.isDelayed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(task.title),
        subtitle: task.dueDate != null
            ? Text('마감: ${task.dueDate!.month}/${task.dueDate!.day}')
            : null,
        trailing: isDelayed ? const DelayedBadge() : null,
        onTap: () {
          if (isDelayed) {
            Navigator.pushNamed(context, '/interview', arguments: task);
          }
        },
      ),
    );
  }
}
