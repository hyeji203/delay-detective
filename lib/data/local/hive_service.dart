import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/task.dart';

class HiveService {
  static const String _tasksBox = 'tasks';
  static const String _syncQueueBox = 'sync_queue';

  late Box<String> _tasks;
  late Box<String> _syncQueue;

  Future<void> init() async {
    await Hive.initFlutter();
    _tasks = await Hive.openBox<String>(_tasksBox);
    _syncQueue = await Hive.openBox<String>(_syncQueueBox);
  }

  Future<List<Task>> getAllTasks() async {
    try {
      return _tasks.values
          .map((s) => Task.fromMap(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // 구 형식(Map) 데이터 감지 시 자동 초기화
      await _tasks.clear();
      return [];
    }
  }

  Future<void> saveTask(Task task) async {
    await _tasks.put(task.id, jsonEncode(task.toMap()));
  }

  Future<void> deleteTask(String id) async {
    await _tasks.delete(id);
  }

  Future<void> clearAll() async {
    await _tasks.clear();
    await _syncQueue.clear();
  }

  Future<void> enqueueSync(String taskId) async {
    await _syncQueue.put(taskId, taskId);
  }

  Future<List<String>> getPendingSyncIds() async {
    return _syncQueue.values.toList();
  }

  Future<void> dequeueSync(String taskId) async {
    await _syncQueue.delete(taskId);
  }
}
