import 'package:flutter/material.dart';
import '../../domain/models/delay_analysis.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  late List<bool> _checked;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final analysis =
        ModalRoute.of(context)?.settings.arguments as DelayAnalysis?;
    _checked = List.filled(analysis?.suggestedSubtasks.length ?? 0, false);
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

    return Scaffold(
      appBar: AppBar(title: const Text('분석 결과')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 공감 카드
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💙', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      analysis.empathyMessage,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 원인 요약
          const Text(
            '지연 원인',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border.all(color: Colors.orange.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              analysis.causeSummary,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),

          if (analysis.suggestedSubtasks.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              '지금 당장 시작할 수 있는 것',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              '작은 것부터 하나씩 해봐요',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...analysis.suggestedSubtasks.asMap().entries.map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  value: _checked[entry.key],
                  onChanged: (v) {
                    setState(() => _checked[entry.key] = v ?? false);
                  },
                  title: Text(
                    entry.value.title,
                    style: TextStyle(
                      decoration: _checked[entry.key]
                          ? TextDecoration.lineThrough
                          : null,
                      color: _checked[entry.key] ? Colors.grey : null,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('홈으로 돌아가기'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
