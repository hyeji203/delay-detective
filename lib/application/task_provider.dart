import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/models/sub_task.dart';
import '../domain/enums/task_status.dart';
import '../data/local/hive_service.dart';

class TaskProvider extends ChangeNotifier {
  final HiveService _hive;

  TaskProvider({required HiveService hive}) : _hive = hive;

  List<Task> _tasks = [];

  // 지연 태스크 — 상단에 정렬되어 표시
  List<Task> get delayedTasks =>
      _tasks.where((t) => t.isDelayed).toList();

  // 일반 태스크
  List<Task> get normalTasks =>
      _tasks.where((t) => !t.isDelayed).toList();

  // 앱 시작 시 Hive에서 태스크 불러오기
  Future<void> loadTasks() async {
    _tasks = await _hive.getAllTasks();
    checkDelayStatus();
    notifyListeners();
  }

  // 지연 감지 규칙: dueDate < 오늘 AND status != done → isDelayed = true
  void checkDelayStatus() {
    for (final task in _tasks) {
      if (task.shouldBeDelayed && !task.isDelayed) {
        task.isDelayed = true;
        task.status = TaskStatus.delayed;
      }
    }
  }

  // 태스크 추가 — Hive에 즉시 저장 후 화면 갱신
  Future<void> addTask(Task task) async {
    await _hive.saveTask(task);
    await _hive.enqueueSync(task.id);
    _tasks.add(task);
    notifyListeners();
  }

  // 태스크 수정 — updatedAt 갱신 후 저장
  Future<void> updateTask(Task task) async {
    task.updatedAt = DateTime.now();
    await _hive.saveTask(task);
    await _hive.enqueueSync(task.id);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _tasks[index] = task;
    notifyListeners();
  }

  // 태스크 삭제
  Future<void> deleteTask(String id) async {
    await _hive.deleteTask(id);
    await _hive.enqueueSync(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // AI 분석 결과 소태스크 적용
  Future<void> applySubtasks(String taskId, List<SubTask> subtasks) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.subtasks = subtasks;
    await updateTask(task);
  }
}
