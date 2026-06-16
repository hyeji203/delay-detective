import '../enums/task_status.dart';
import 'sub_task.dart';
import 'delay_analysis.dart';

class Task {
  final String id;          // UUID (로컬에서 생성)
  final String uid;         // Firebase 익명 UID
  String title;
  String? description;
  DateTime? dueDate;
  TaskStatus status;
  bool isDelayed;
  final DateTime createdAt;
  DateTime updatedAt;       // Conflict Resolution 기준
  List<SubTask> subtasks;   // AI 분해 결과 (최대 3개)
  DelayAnalysis? analysis;  // AI 인터뷰 결과

  Task({
    required this.id,
    required this.uid,
    required this.title,
    this.description,
    this.dueDate,
    this.status = TaskStatus.todo,
    this.isDelayed = false,
    required this.createdAt,
    required this.updatedAt,
    this.subtasks = const [],
    this.analysis,
  });

  // 지연 판정 규칙: dueDate가 어제 이전(날짜 단위) AND 완료되지 않은 상태
  bool get shouldBeDelayed {
    if (dueDate == null || status == TaskStatus.done) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return dueDay.isBefore(today);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': uid,
        'title': title,
        'description': description,
        'dueDate': dueDate?.toIso8601String(),
        'status': status.name,
        'isDelayed': isDelayed,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'subtasks': subtasks.map((s) => s.toMap()).toList(),
        'analysis': analysis?.toMap(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        uid: map['uid'] as String,
        title: map['title'] as String,
        description: map['description'] as String?,
        dueDate: map['dueDate'] != null
            ? DateTime.parse(map['dueDate'] as String)
            : null,
        status: TaskStatus.values.byName(map['status'] as String),
        isDelayed: map['isDelayed'] as bool? ?? false,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        subtasks: (map['subtasks'] as List<dynamic>? ?? [])
            .map((s) => SubTask.fromMap(s as Map<String, dynamic>))
            .toList(),
        analysis: map['analysis'] != null
            ? DelayAnalysis.fromMap(map['analysis'] as Map<String, dynamic>)
            : null,
      );
}
