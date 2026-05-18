import '../../domain/models/task.dart';

// Primary 저장소 — 모든 읽기·쓰기의 1순위
class HiveService {
  static const String _tasksBox = 'tasks';
  static const String _syncQueueBox = 'sync_queue';

  // 구현 예정: Hive 초기화
  Future<void> init() async {}

  // 구현 예정: 태스크 전체 조회
  Future<List<Task>> getAllTasks() async => [];

  // 구현 예정: 태스크 저장 (생성 또는 업데이트)
  Future<void> saveTask(Task task) async {}

  // 구현 예정: 태스크 삭제
  Future<void> deleteTask(String id) async {}

  // 구현 예정: sync_queue에 taskId 등록
  Future<void> enqueueSync(String taskId) async {}

  // 구현 예정: 대기 중인 sync_queue 목록 반환
  Future<List<String>> getPendingSyncIds() async => [];

  // 구현 예정: sync_queue에서 제거 (Firestore 업로드 성공 후)
  Future<void> dequeueSync(String taskId) async {}
}
