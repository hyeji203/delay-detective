import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/task.dart';

class HiveService {
  static const String _tasksBox = 'tasks';
  static const String _syncQueueBox = 'sync_queue';

  late Box<Map> _tasks;
  late Box<String> _syncQueue;

  Future<void> init() async {
    await Hive.initFlutter();
    _tasks = await Hive.openBox<Map>(_tasksBox);
    _syncQueue = await Hive.openBox<String>(_syncQueueBox);
  }

  Future<List<Task>> getAllTasks() async {
    return _tasks.values
        .map((m) => Task.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<void> saveTask(Task task) async {
    await _tasks.put(task.id, task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _tasks.delete(id);
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
