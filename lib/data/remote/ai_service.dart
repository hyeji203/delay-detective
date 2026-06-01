import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/task.dart';
import '../../domain/models/delay_analysis.dart';
import '../../domain/models/interview_turn.dart';
import '../../domain/models/sub_task.dart';

class AIService {
  static const int maxTurns = 3;
  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  static const String _interviewSystemPrompt = '''
You must respond ONLY in Korean (한국어). Never use any other language including English, Vietnamese, Chinese, or Japanese.

당신은 공감 능력이 뛰어난 생산성 코치입니다.
사용자가 미루고 있는 태스크에 대해 따뜻하고 짧은 질문 하나만 합니다.
질문은 판단 없이 호기심 어린 톤으로, 1~2문장 이내로 작성하세요.
추가 설명이나 조언은 하지 마세요. 오직 순수한 한국어 질문만 하세요.
한국어 이외의 단어를 절대 사용하지 마세요.
''';

  String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  Future<String> startInterview(Task task) async {
    final messages = [
      {'role': 'system', 'content': _interviewSystemPrompt},
      {'role': 'user', 'content': _buildTaskIntro(task)},
    ];
    return _chat(messages);
  }

  Future<String> continueInterview(
    Task task,
    List<InterviewTurn> previousTurns,
    int currentTurn,
  ) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': _interviewSystemPrompt},
      {'role': 'user', 'content': _buildTaskIntro(task)},
    ];

    for (final turn in previousTurns) {
      messages.add({'role': 'assistant', 'content': turn.question});
      messages.add({'role': 'user', 'content': turn.answer});
    }

    return _chat(messages);
  }

  Future<DelayAnalysis> parseResult(
    List<InterviewTurn> turns,
    String rawResponse,
  ) async {
    final conversation =
        turns.map((t) => 'Q: ${t.question}\nA: ${t.answer}').join('\n\n');

    final messages = [
      {
        'role': 'system',
        'content': '당신은 JSON만 출력하는 분석가입니다. 코드블록 없이 순수 JSON만 반환하세요.',
      },
      {
        'role': 'user',
        'content': '''
다음은 사용자의 미루는 태스크에 대한 인터뷰 내용입니다:

$conversation

위 내용을 분석해서 아래 JSON 형식으로만 응답하세요:
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

    final response = await _chat(messages);
    return _parseAnalysisJson(response, turns);
  }

  Future<String> _chat(List<Map<String, dynamic>> messages) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'max_tokens': 512,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI API 오류 ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>;
    final message = choices.first['message'] as Map<String, dynamic>;
    return message['content'] as String;
  }

  DelayAnalysis _parseAnalysisJson(String raw, List<InterviewTurn> turns) {
    try {
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
