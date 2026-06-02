import 'package:flutter/material.dart';
import '../../domain/models/delay_analysis.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  late List<bool> _checked;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final analysis =
          ModalRoute.of(context)?.settings.arguments as DelayAnalysis?;
      _checked = List.filled(analysis?.suggestedSubtasks.length ?? 0, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysis =
        ModalRoute.of(context)?.settings.arguments as DelayAnalysis?;

    if (analysis == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('분석 결과')),
        body: const Center(child: Text('결과가 없어요')),
      );
    }

    final allDone = _checked.isNotEmpty && _checked.every((c) => c);

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        automaticallyImplyLeading: false,
        actions: [
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
                    analysis.empathyMessage,
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
                        analysis.causeSummary,
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
              (entry) => GestureDetector(
                onTap: () =>
                    setState(() => _checked[entry.key] = !_checked[entry.key]),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _checked[entry.key]
                        ? const Color(0xFF3F51B5).withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _checked[entry.key]
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
                          color: _checked[entry.key]
                              ? const Color(0xFF3F51B5)
                              : Colors.transparent,
                          border: Border.all(
                            color: _checked[entry.key]
                                ? const Color(0xFF3F51B5)
                                : const Color(0xFFCCCCDD),
                            width: 1.5,
                          ),
                        ),
                        child: _checked[entry.key]
                            ? const Icon(Icons.check,
                                size: 13, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: _checked[entry.key]
                                ? const Color(0xFF9E9EAE)
                                : const Color(0xFF1A1A2E),
                            decoration: _checked[entry.key]
                                ? TextDecoration.lineThrough
                                : null,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
