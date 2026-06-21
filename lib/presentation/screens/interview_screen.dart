import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/ai_provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final _answerController = TextEditingController();
  final _scrollController = ScrollController();
  Task? _task;
  bool _initialized = false;

  @override
  void dispose() {
    _answerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _task = ModalRoute.of(context)?.settings.arguments as Task?;
      if (_task != null) {
        Future.microtask(() {
          if (mounted) context.read<AIProvider>().startInterview(_task!);
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _submit() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    _answerController.clear();
    final ai = context.read<AIProvider>();
    final task = _task!;

    await ai.submitAnswer(task, answer);
    _scrollToBottom();

    if (ai.isDone && mounted) {
      final taskProvider = context.read<TaskProvider>();
      final result = ai.result!;
      await taskProvider.applySubtasks(task.id, result.suggestedSubtasks);
      await taskProvider.saveAnalysis(task.id, result);
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: {'task': task, 'analysis': result},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AIProvider>();
    const maxTurns = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('미루는 이유 찾기'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<AIProvider>().reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // 진행 표시
          LinearProgressIndicator(
            value: ai.currentTurn / maxTurns,
            backgroundColor: Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${ai.currentTurn} / $maxTurns 질문',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          // 대화 목록
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // 이전 턴들
                ...ai.turns.expand((turn) => [
                      _AiMessage(message: turn.question),
                      const SizedBox(height: 8),
                      _UserMessage(message: turn.answer),
                      const SizedBox(height: 16),
                    ]),

                // 현재 AI 질문
                if (ai.isInterviewing && ai.currentQuestion.isNotEmpty) ...[
                  _AiMessage(message: ai.currentQuestion),
                  const SizedBox(height: 8),
                ],

                // 로딩 상태
                if (ai.state == InterviewState.analyzing ||
                    (ai.isInterviewing && ai.currentQuestion.isEmpty))
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('생각 중...'),
                      ],
                    ),
                  ),

                // 에러
                if (ai.state == InterviewState.error)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ai.errorMessage ?? '오류가 발생했어요',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),

          // 답변 입력창
          if (ai.isInterviewing && ai.currentQuestion.isNotEmpty)
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        hintText: '솔직하게 말해보세요...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  final String message;
  const _AiMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(message),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String message;
  const _UserMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(message),
      ),
    );
  }
}
