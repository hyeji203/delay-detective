import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get delayedTasks => _tasks.where((t) => t.isDelayed).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void completeTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = true;
      _tasks[index].lastModified = DateTime.now();
      notifyListeners();
    }
  }

  void loadTasks(List<Task> tasks) {
    _tasks
      ..clear()
      ..addAll(tasks);
    notifyListeners();
  }
}
