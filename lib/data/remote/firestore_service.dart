import '../../domain/models/task.dart';

// Secondary 저장소 — 백그라운드 동기화 담당
class FirestoreService {
  // 구현 예정: 태스크 업로드 (Hive → Firestore)
  Future<void> uploadTask(Task task) async {}

  // 구현 예정: 태스크 다운로드 (Firestore → Hive)
  Future<Task?> fetchTask(String uid, String taskId) async => null;

  // 구현 예정: 전체 태스크 목록 다운로드
  Future<List<Task>> fetchAllTasks(String uid) async => [];

  // 구현 예정: 태스크 삭제
  Future<void> deleteTask(String uid, String taskId) async {}
}
