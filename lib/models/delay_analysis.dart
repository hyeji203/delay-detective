class DelayAnalysis {
  final String taskId;
  final String taskTitle;
  final String aiQuestion;
  final String? userResponse;
  final List<String>? subtasks;
  final DateTime createdAt;

  DelayAnalysis({
    required this.taskId,
    required this.taskTitle,
    required this.aiQuestion,
    this.userResponse,
    this.subtasks,
    required this.createdAt,
  });
}
