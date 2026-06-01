import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/models/interview_turn.dart';
import '../domain/models/delay_analysis.dart';
import '../data/remote/ai_service.dart';

enum InterviewState { idle, interviewing, analyzing, done, error }

class AIProvider extends ChangeNotifier {
  final AIService _aiService;

  AIProvider({required AIService aiService}) : _aiService = aiService;

  InterviewState state = InterviewState.idle;
  int currentTurn = 0;           // 0 → 1 → 2 → 3
  List<InterviewTurn> turns = [];
  String currentQuestion = '';   // AI가 현재 묻는 질문
  DelayAnalysis? result;
  String? errorMessage;

  bool get isInterviewing => state == InterviewState.interviewing;
  bool get isDone => state == InterviewState.done;

  // 인터뷰 시작 — 턴 1 질문 가져오기
  Future<void> startInterview(Task task) async {
    reset();
    state = InterviewState.interviewing;
    currentTurn = 1;
    notifyListeners();

    try {
      currentQuestion = await _aiService.startInterview(task);
      notifyListeners();
    } catch (e) {
      state = InterviewState.error;
      errorMessage = '에러: $e';
      notifyListeners();
    }
  }

  // 사용자 답변 제출 — 다음 턴 진행
  Future<void> submitAnswer(Task task, String answer) async {
    final turn = InterviewTurn(
      turnNumber: currentTurn,
      question: currentQuestion,
      answer: answer,
    );
    turns.add(turn);

    if (currentTurn >= AIService.maxTurns) {
      // 턴 3 완료 → 결과 파싱
      state = InterviewState.analyzing;
      notifyListeners();
      try {
        result = await _aiService.parseResult(turns, answer);
        state = InterviewState.done;
      } catch (e) {
        state = InterviewState.error;
        errorMessage = '분석에 실패했어요. 다시 시도해주세요.';
      }
    } else {
      // 다음 턴 질문 가져오기
      currentTurn++;
      try {
        currentQuestion = await _aiService.continueInterview(
          task, turns, currentTurn,
        );
      } catch (e) {
        state = InterviewState.error;
        errorMessage = '연결이 끊어졌어요. 다시 시도해주세요.';
      }
    }
    notifyListeners();
  }

  void reset() {
    state = InterviewState.idle;
    currentTurn = 0;
    turns = [];
    currentQuestion = '';
    result = null;
    errorMessage = null;
    notifyListeners();
  }
}
