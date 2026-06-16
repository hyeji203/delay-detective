import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/delay_analysis.dart';
import '../../domain/models/task.dart';

// 한자·히라가나·가타카나·키릴 문자 제거 (유니코드 이스케이프 사용)
String _sanitize(String text) => text.replaceAll(
      RegExp('[一-鿿㐀-䶿豈-﫿'
          '぀-ゟ゠-ヿЀ-ӿ]'),
      '',
    );

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  Task? _task;
  DelayAnalysis? _analysis;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _task = args['task'] as Task?;
        _analysis = args['analysis'] as DelayAnalysis?;
      } else if (args is DelayAnalysis) {
        _analysis = args;
      }
    }
  }

  Future<void> _toggleSubtask(String subtaskId) async {
    if (_task == null) return;
    final provider = context.read<TaskProvider>();
    await provider.toggleSubtask(_task!.id, subtaskId);
    if (!mounted) return;
    final updated = provider.getTaskById(_task!.id);
    if (updated != null) setState(() => _task = updated);
  }

  @override
  Widget build(BuildContext context) {
    final analysis = _analysis ?? _task?.analysis;

    if (analysis == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('분석 결과')),
        body: const Center(child: Text('결과가 없어요')),
      );
    }

    // subtask 완료 상태: task에 저장된 값 우선 사용
    List<bool> checked;
    if (_task != null && _task!.subtasks.isNotEmpty) {
      checked = _task!.subtasks.map((s) => s.isDone).toList();
    } else {
      checked = List.filled(analysis.suggestedSubtasks.length, false);
    }

    final allDone = checked.isNotEmpty && checked.every((c) => c);

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        automaticallyImplyLeading: false,
        actions: [
          if (_task != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
              tooltip: '삭제',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('태스크 삭제'),
                    content: const Text('분석 결과도 함께 삭제됩니다. 삭제할까요?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: Color(0xFFEF5350)),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  context.read<TaskProvider>().deleteTask(_task!.id);
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text(
              '홈으로',
              style: TextStyle(color: Color(0xFF3F51B5)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 공감 카드
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💙', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _sanitize(analysis.empathyMessage),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 원인 카드
          Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🔍', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '지연 원인',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9E9EAE),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _sanitize(analysis.causeSummary),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A2E),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (analysis.suggestedSubtasks.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Row(
              children: [
                Text(
                  '지금 바로 할 수 있는 것',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(width: 6),
                Text('✨', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '작은 것 하나씩만 해봐요',
              style: TextStyle(fontSize: 13, color: Color(0xFF9E9EAE)),
            ),
            const SizedBox(height: 12),
            ...analysis.suggestedSubtasks.asMap().entries.map(
              (entry) {
                final idx = entry.key;
                final sub = entry.value;
                final isDone = idx < checked.length ? checked[idx] : false;

                return GestureDetector(
                  onTap: () => _task != null
                      ? _toggleSubtask(sub.id)
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFF3F51B5).withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF3F51B5).withOpacity(0.3)
                            : const Color(0xFFEEEEF5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? const Color(0xFF3F51B5)
                                : Colors.transparent,
                            border: Border.all(
                              color: isDone
                                  ? const Color(0xFF3F51B5)
                                  : const Color(0xFFCCCCDD),
                              width: 1.5,
                            ),
                          ),
                          child: isDone
                              ? const Icon(Icons.check,
                                  size: 13, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _sanitize(sub.title),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDone
                                  ? const Color(0xFF9E9EAE)
                                  : const Color(0xFF1A1A2E),
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 24),
          if (allDone)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🎉', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    '모두 완료했어요! 잘 했어요',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
