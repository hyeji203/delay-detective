class SubTask {
  final String id;
  String title;   // "15분 안에 할 수 있는 단위"
  bool isDone;

  SubTask({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isDone': isDone,
      };

  factory SubTask.fromMap(Map<String, dynamic> map) => SubTask(
        id: map['id'] as String,
        title: map['title'] as String,
        isDone: map['isDone'] as bool? ?? false,
      );
}
