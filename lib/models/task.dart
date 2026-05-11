import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  late DateTime dueDate;

  @HiveField(4)
  late bool isCompleted;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  late DateTime lastModified;

  @HiveField(7)
  late String category;

  @HiveField(8)
  bool isSynced;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
    required this.lastModified,
    this.category = '기타',
    this.isSynced = false,
  });

  bool get isDelayed =>
      !isCompleted && dueDate.isBefore(DateTime.now());

  int get delayDays =>
      isDelayed ? DateTime.now().difference(dueDate).inDays : 0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'lastModified': lastModified.toIso8601String(),
        'category': category,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        dueDate: DateTime.parse(map['dueDate']),
        isCompleted: map['isCompleted'] ?? false,
        createdAt: DateTime.parse(map['createdAt']),
        lastModified: DateTime.parse(map['lastModified']),
        category: map['category'] ?? '기타',
        isSynced: true,
      );
}
