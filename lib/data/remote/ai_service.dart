import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/task.dart';
import '../../domain/models/delay_analysis.dart';
import '../../domain/models/interview_turn.dart';
import '../../domain/models/sub_task.dart';

class AIService {
  static const int maxTurns = 3;
  static const String _endpoint = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';

  // 4.2 — 인터뷰 시스템 프롬프트
  static const String _interviewSystemPrompt = '''
당신은 공감 능력이 뛰어난 생산성 코치입니다.
사용자가 미루고 있는 태스크에 대해 따뜻하고 짧은 질문 하나만 합니다.
질문은 판단 없이 호기심 어린 톤으로, 1~2문장 이내로 작성하세요.
추가 설명이나 조언은 하지 마세요. 오직 질문만 하세요.
''';

  String get _apiKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  // 4.1 — 턴 1: 인터뷰 시작
  Future<String> startInterview(Task task) async {
    final messages = [
      {
        'role': 'user',
        'content': _buildTaskIntro(task),
      },
    ];
    return _chat(_interviewSystemPrompt, messages);
  }

  // 4.1 — 턴 2~3: 이전 대화 맥락 포함 후속 질문
  Future<String> continueInterview(
    Task task,
    List<InterviewTurn> previousTurns,
    int currentTurn,
  ) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'user', 'content': _buildTaskIntro(task)},
    ];

    for (final turn in previousTurns) {
      messages.add({'role': 'assistant', 'content': turn.question});
      messages.add({'role': 'user', 'content': turn.answer});
    }

    return _chat(_interviewSystemPrompt, messages);
  }

  // 4.3 — 인터뷰 결과 파싱: empathy + cause + subtasks JSON 추출
  Future<DelayAnalysis> parseResult(
    List<InterviewTurn> turns,
    String rawResponse,
  ) async {
    final conversation =
        turns.map((t) => 'Q: ${t.question}\nA: ${t.answer}').join('\n\n');

    final messages = [
      {
        'role': 'user',
        'content': '''
다음은 사용자의 미루는 태스크에 대한 인터뷰 내용입니다:

$conversation

위 내용만 보고 아래 JSON 형식으로만 응답하세요. 코드블록이나 다른 텍스트 없이 JSON만 출력하세요:
{
  "empathy": "사용자에게 전달할 공감 메시지 (따뜻한 한 문장)",
  "cause": "지연 원인 핵심 요약 (한 문장)",
  "subtasks": [
    {"title": "지금 당장 15분 안에 할 수 있는 첫 번째 작은 단계"},
    {"title": "두 번째 작은 단계"},
    {"title": "세 번째 작은 단계"}
  ]
}
''',
      },
    ];

    final response = await _chat(_interviewSystemPrompt, messages);
    return _parseAnalysisJson(response, turns);
  }

  // Anthropic Messages API 호출
  Future<String> _chat(
    String systemPrompt,
    List<Map<String, dynamic>> messages,
  ) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 512,
        'system': systemPrompt,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI API 오류 ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return (content.first as Map<String, dynamic>)['text'] as String;
  }

  // 4.3 — JSON 파싱 및 폴백 처리
  DelayAnalysis _parseAnalysisJson(String raw, List<InterviewTurn> turns) {
    try {
      // 마크다운 코드블록 제거 후 JSON 추출
      String jsonStr = raw.trim();
      if (jsonStr.contains('```')) {
        final start = jsonStr.indexOf('{');
        final end = jsonStr.lastIndexOf('}');
        jsonStr = jsonStr.substring(start, end + 1);
      }

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final subtasksRaw = map['subtasks'] as List<dynamic>? ?? [];
      final subtasks = subtasksRaw
          .asMap()
          .entries
          .map((e) => SubTask(
                id: 'sub_${e.key}',
                title: (e.value as Map<String, dynamic>)['title'] as String,
              ))
          .toList();

      return DelayAnalysis(
        empathyMessage: map['empathy'] as String,
        causeSummary: map['cause'] as String,
        analyzedAt: DateTime.now(),
        turns: turns,
        suggestedSubtasks: subtasks,
      );
    } catch (_) {
      return DelayAnalysis(
        empathyMessage: '미루는 게 때로는 자연스러운 일이에요.',
        causeSummary: '시작하기 어려운 이유가 있었네요.',
        analyzedAt: DateTime.now(),
        turns: turns,
      );
    }
  }

  String _buildTaskIntro(Task task) {
    final parts = ['태스크: "${task.title}"'];
    if (task.description != null) parts.add('설명: ${task.description}');
    if (task.dueDate != null) {
      parts.add('마감일: ${task.dueDate!.toLocal().toString().split(' ').first}');
    }
    return parts.join('\n');
  }
}
