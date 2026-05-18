import 'interview_turn.dart';

class DelayAnalysis {
  String empathyMessage;  // "오래된 일이라 부담됐겠다"
  String causeSummary;    // "시작점이 불명확해서"
  List<InterviewTurn> turns;
  final DateTime analyzedAt;

  DelayAnalysis({
    required this.empathyMessage,
    required this.causeSummary,
    required this.turns,
    required this.analyzedAt,
  });

  Map<String, dynamic> toMap() => {
        'empathyMessage': empathyMessage,
        'causeSummary': causeSummary,
        'analyzedAt': analyzedAt.toIso8601String(),
        'turns': turns.map((t) => t.toMap()).toList(),
      };

  factory DelayAnalysis.fromMap(Map<String, dynamic> map) => DelayAnalysis(
        empathyMessage: map['empathyMessage'] as String,
        causeSummary: map['causeSummary'] as String,
        analyzedAt: DateTime.parse(map['analyzedAt'] as String),
        turns: (map['turns'] as List<dynamic>)
            .map((t) => InterviewTurn.fromMap(t as Map<String, dynamic>))
            .toList(),
      );
}
