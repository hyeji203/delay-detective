class InterviewTurn {
  final int turnNumber;  // 1, 2, 3
  final String question; // AI가 한 질문
  final String answer;   // 사용자 답변

  const InterviewTurn({
    required this.turnNumber,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toMap() => {
        'turnNumber': turnNumber,
        'question': question,
        'answer': answer,
      };

  factory InterviewTurn.fromMap(Map<String, dynamic> map) => InterviewTurn(
        turnNumber: map['turnNumber'] as int,
        question: map['question'] as String,
        answer: map['answer'] as String,
      );
}
