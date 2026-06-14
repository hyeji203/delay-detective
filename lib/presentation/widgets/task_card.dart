import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';
import '../../domain/enums/task_status.dart';

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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (isDelayed)
                _OptionTile(
                  icon: Icons.psychology_outlined,
                  label: 'AI에게 이유 물어보기',
                  color: const Color(0xFF3F51B5),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/interview', arguments: task);
                  },
                ),
              if (task.analysis != null)
                _OptionTile(
                  icon: Icons.history_outlined,
                  label: '분석 결과 보기',
                  color: const Color(0xFF7B61FF),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/result',
                      arguments: {'task': task, 'analysis': task.analysis},
                    );
                  },
                ),
              _OptionTile(
                icon: Icons.edit_outlined,
                label: '수정하기',
                color: const Color(0xFF3F51B5),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-task', arguments: task);
                },
              ),
              if (!isDelayed)
                _OptionTile(
                  icon: Icons.access_time_outlined,
                  label: '미루고 있어요',
                  color: const Color(0xFFEF5350),
                  onTap: () {
                    Navigator.pop(context);
                    _markDelayed(context);
                  },
                ),
              _OptionTile(
                icon: Icons.check_circle_outline,
                label: '완료했어요',
                color: const Color(0xFF43A047),
                onTap: () {
                  Navigator.pop(context);
                  _markDone(context);
                },
              ),
              _OptionTile(
                icon: Icons.delete_outline,
                label: '삭제',
                color: Colors.grey,
                onTap: () {
                  Navigator.pop(context);
                  context.read<TaskProvider>().deleteTask(task.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int? daysLeft;
    if (task.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDay = DateTime(
          task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      daysLeft = dueDay.difference(today).inDays;
    }
    final isTodayDue = daysLeft == 0 && !isDelayed;

    return GestureDetector(
      onTap: () => isDelayed
          ? Navigator.pushNamed(context, '/interview', arguments: task)
          : _showOptions(context),
      onLongPress: () => _showOptions(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isTodayDue ? const Color(0xFFFFF8F0) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isDelayed
              ? Border.all(color: const Color(0xFFEF5350).withOpacity(0.3))
              : isTodayDue
                  ? Border.all(color: const Color(0xFFFF9800).withOpacity(0.6))
                  : null,
          boxShadow: [
            BoxShadow(
              color: isTodayDue
                  ? const Color(0xFFFF9800).withOpacity(0.10)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isDelayed)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                )
              else if (isTodayDue)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isTodayDue
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isTodayDue
                                ? Icons.access_alarm
                                : Icons.calendar_today_outlined,
                            size: 11,
                            color: isDelayed
                                ? const Color(0xFFEF5350)
                                : isTodayDue
                                    ? const Color(0xFFE65100)
                                    : const Color(0xFF9E9EAE),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(daysLeft, task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDelayed
                                  ? const Color(0xFFEF5350)
                                  : isTodayDue
                                      ? const Color(0xFFE65100)
                                      : const Color(0xFF9E9EAE),
                              fontWeight: (isDelayed || isTodayDue)
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isDelayed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF5350).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AI 분석',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFEF5350),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (isTodayDue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 12, color: Color(0xFFE65100)),
                      SizedBox(width: 3),
                      Text(
                        '오늘 마감',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(int? daysLeft, DateTime dueDate) {
    if (daysLeft == null) return '';
    if (daysLeft < 0) return '${daysLeft.abs()}일 지났어요';
    if (daysLeft == 0) return '오늘 마감';
    if (daysLeft == 1) return '내일 마감';
    return 'D-$daysLeft';
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
