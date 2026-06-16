import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/enums/task_status.dart';
import '../widgets/profile_button.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final all = [...provider.activeTasks, ...provider.completedTasks];
    final total = all.length;

    if (total == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('통계'),
          actions: const [ProfileButton()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFEEEEF5)),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📊', style: TextStyle(fontSize: 48)),
              SizedBox(height: 16),
              Text(
                '아직 데이터가 없어요',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '할일을 추가하면 통계가 쌓여요',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9EAE)),
              ),
            ],
          ),
        ),
      );
    }

    final completed = all.where((t) => t.status == TaskStatus.done).length;
    final delayed = all.where((t) => t.isDelayed).length;
    final analyzed = all.where((t) => t.analysis != null).length;
    final completionRate = completed / total;

    final tasksWithSubs = all.where((t) => t.subtasks.isNotEmpty).toList();
    final totalSubs =
        tasksWithSubs.fold(0, (sum, t) => sum + t.subtasks.length);
    final doneSubs = tasksWithSubs.fold(
        0, (sum, t) => sum + t.subtasks.where((s) => s.isDone).length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
        actions: const [ProfileButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 요약 카드
          Row(
            children: [
              _StatCard(
                label: '전체',
                value: '$total',
                color: const Color(0xFF3F51B5),
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: '지연중',
                value: '$delayed',
                color: const Color(0xFFEF5350),
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: '완료',
                value: '$completed',
                color: const Color(0xFF43A047),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 완료율
          _SectionCard(
            title: '완료율',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(completionRate * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    Text(
                      '$completed / $total',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E9EAE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: completionRate,
                    backgroundColor: const Color(0xFFEEEEF5),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF3F51B5)),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 태스크 현황
          _SectionCard(
            title: '태스크 현황',
            child: Column(
              children: [
                _StatBar(
                  label: '완료',
                  count: completed,
                  total: total,
                  color: const Color(0xFF43A047),
                ),
                const SizedBox(height: 10),
                _StatBar(
                  label: '지연중',
                  count: delayed,
                  total: total,
                  color: const Color(0xFFEF5350),
                ),
                const SizedBox(height: 10),
                _StatBar(
                  label: '진행중',
                  count: total - completed - delayed,
                  total: total,
                  color: const Color(0xFF3F51B5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // AI 분석 현황
          _SectionCard(
            title: 'AI 분석 현황',
            child: Column(
              children: [
                _StatRow(
                  label: 'AI 분석 완료',
                  value: '$analyzed건',
                  color: const Color(0xFF7B61FF),
                ),
                if (totalSubs > 0) ...[
                  const SizedBox(height: 14),
                  _StatRow(
                    label: '소태스크 진행률',
                    value: '$doneSubs / $totalSubs',
                    color: const Color(0xFF43A047),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalSubs > 0 ? doneSubs / totalSubs : 0,
                      backgroundColor: const Color(0xFFEEEEF5),
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFF43A047)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
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
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9E9EAE),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9E9EAE),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? count / total : 0.0;
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5A5A7A)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: const Color(0xFFEEEEF5),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

