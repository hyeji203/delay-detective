import '../local/hive_service.dart';
import '../remote/firestore_service.dart';

// Hive ↔ Firestore 동기화 — sync_queue 기반
class SyncService {
  final HiveService _hive;
  final FirestoreService _firestore;

  SyncService({
    required HiveService hive,
    required FirestoreService firestore,
  })  : _hive = hive,
        _firestore = firestore;

  // 네트워크 연결 시 queue에 쌓인 변경 사항을 Firestore로 업로드
  Future<void> flushQueue(String uid) async {
    final pendingIds = await _hive.getPendingSyncIds();

    for (final taskId in pendingIds) {
      try {
        final tasks = await _hive.getAllTasks();
        final task = tasks.where((t) => t.id == taskId).firstOrNull;

        if (task != null) {
          await _firestore.uploadTask(task);
        } else {
          await _firestore.deleteTask(uid, taskId);
        }

        await _hive.dequeueSync(taskId);
      } catch (_) {
        // 구현 예정: 업로드 실패 시 다음 연결 때 재시도
      }
    }
  }

  // Conflict Resolution: updatedAt 기준 최신값 우선 (Last-Write-Wins)
  // 구현 예정: Firestore 데이터를 Hive와 비교 후 병합
  Future<void> mergeFromFirestore(String uid) async {}
}
