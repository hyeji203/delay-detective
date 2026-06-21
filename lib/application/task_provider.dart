import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/models/sub_task.dart';
import '../domain/enums/task_status.dart';
import '../data/local/hive_service.dart';
import '../data/remote/firestore_service.dart';

class TaskProvider extends ChangeNotifier {
  final HiveService _hive;
  final FirestoreService? _firestore;
  final String? _uid;

  TaskProvider({
    required HiveService hive,
    FirestoreService? firestore,
    String? uid,
  })  : _hive = hive,
        _firestore = firestore,
        _uid = uid {
    loadTasks();
  }

  String get uid => _uid ?? 'offline';
  String? get rawUid => _uid;

  List<Task> _tasks = [];

  // 지연 태스크 — 상단에 정렬되어 표시
  List<Task> get delayedTasks =>
      _tasks.where((t) => t.isDelayed).toList();

  // 일반 태스크
  List<Task> get normalTasks =>
      _tasks.where((t) => !t.isDelayed).toList();

  // 진행중 태스크 (완료 제외)
  List<Task> get activeTasks =>
      _tasks.where((t) => t.status != TaskStatus.done).toList();

  // 완료된 태스크
  List<Task> get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.done).toList();

  // 앱 시작 시 Hive에서 태스크 불러오기
  Future<void> loadTasks() async {
    if (_uid == 'demo') await _seedDemoTasks();
    _tasks = await _hive.getAllTasks();
    await checkDelayStatus();
    notifyListeners();
  }

  // 데모 모드용 샘플 태스크 (Hive가 비어있을 때만 삽입)
  Future<void> _seedDemoTasks() async {
    final existing = await _hive.getAllTasks();
    if (existing.isNotEmpty) return;
    final now = DateTime.now();
    final demos = [
      Task(
        id: 'demo-1',
        uid: 'demo',
        title: '앱 기획서 작성',
        description: '최종 발표용 Delay Detective 기획서 마무리',
        dueDate: now.subtract(const Duration(days: 3)),
        status: TaskStatus.delayed,
        isDelayed: true,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      Task(
        id: 'demo-2',
        uid: 'demo',
        title: '발표 슬라이드 디자인',
        description: 'Marp 기반 최종 발표 슬라이드 30장 완성',
        dueDate: now.subtract(const Duration(days: 1)),
        status: TaskStatus.delayed,
        isDelayed: true,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      Task(
        id: 'demo-3',
        uid: 'demo',
        title: '코드 리뷰 요청',
        dueDate: now.add(const Duration(days: 2)),
        status: TaskStatus.todo,
        isDelayed: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
    ];
    for (final t in demos) {
      await _hive.saveTask(t);
    }
  }

  // 지연 감지: dueDate가 어제 이전(날짜 단위) AND 미완료 → isDelayed = true, Hive 저장
  Future<void> checkDelayStatus() async {
    for (final task in _tasks) {
      if (task.shouldBeDelayed && !task.isDelayed) {
        task.isDelayed = true;
        task.status = TaskStatus.delayed;
        await _hive.saveTask(task);
      }
    }
  }

  // 태스크 추가 — Hive 저장 후 지연 감지, Firestore 업로드
  Future<void> addTask(Task task) async {
    await _hive.saveTask(task);
    _tasks.add(task);
    await checkDelayStatus();
    notifyListeners();
    await _syncToFirestore(task);
  }

  // 태스크 수정 — updatedAt 갱신 후 저장
  Future<void> updateTask(Task task) async {
    task.updatedAt = DateTime.now();
    await _hive.saveTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _tasks[index] = task;
    notifyListeners();
    await _syncToFirestore(task);
  }

  // 태스크 삭제
  Future<void> deleteTask(String id) async {
    await _hive.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    try {
      if (_firestore != null && _uid != null) {
        await _firestore.deleteTask(_uid, id);
      } else {
        await _hive.enqueueSync(id);
      }
    } catch (_) {
      await _hive.enqueueSync(id);
    }
  }

  Future<void> _syncToFirestore(Task task) async {
    try {
      if (_firestore != null && _uid != null) {
        await _firestore.uploadTask(task);
      } else {
        await _hive.enqueueSync(task.id);
      }
    } catch (_) {
      await _hive.enqueueSync(task.id);
    }
  }

  // AI 분석 결과 소태스크 적용
  Future<void> applySubtasks(String taskId, List<SubTask> subtasks) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.subtasks = subtasks;
    await updateTask(task);
  }

  // 소태스크 완료 토글 → Hive 영구 저장
  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final sub = task.subtasks.firstWhere((s) => s.id == subtaskId);
    sub.isDone = !sub.isDone;
    await updateTask(task);
  }

  // task.analysis를 Hive에 영구 저장
  Future<void> saveAnalysis(String taskId, analysis) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.analysis = analysis;
    await updateTask(task);
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Task> get tasksWithAnalysis =>
      _tasks.where((t) => t.analysis != null).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
}
