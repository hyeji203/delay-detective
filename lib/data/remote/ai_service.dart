import '../../domain/models/task.dart';
import '../../domain/models/delay_analysis.dart';
import '../../domain/models/interview_turn.dart';

// Claude API 연동 — 최대 3턴 고정
class AIService {
  static const int maxTurns = 3;

  // 구현 예정: 턴 1 — 인터뷰 시작 (태스크 정보 주입)
  Future<String> startInterview(Task task) async => '';

  // 구현 예정: 턴 2~3 — 이전 대화 맥락 포함 후속 질문
  Future<String> continueInterview(
    Task task,
    List<InterviewTurn> previousTurns,
    int currentTurn,
  ) async =>
      '';

  // 구현 예정: 턴 3 응답에서 결과 파싱
  // 반환 형식: { empathy: string, cause: string, subtasks: [{title}] }
  Future<DelayAnalysis> parseResult(
    List<InterviewTurn> turns,
    String rawResponse,
  ) async =>
      throw UnimplementedError();
}
