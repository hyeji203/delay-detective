import 'package:flutter/material.dart';
import '../data/sync/sync_service.dart';

enum SyncStatus { synced, syncing, offline, error }

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService;
  final String uid;

  SyncProvider({required SyncService syncService, required this.uid})
      : _syncService = syncService;

  SyncStatus status = SyncStatus.offline;

  bool get isOnline => status == SyncStatus.synced || status == SyncStatus.syncing;

  // 네트워크 상태 변경 시 호출 (connectivity_plus에서 감지)
  void onConnectivityChanged(bool isOnline) {
    if (isOnline) {
      flushQueue();
    } else {
      status = SyncStatus.offline;
      notifyListeners();
    }
  }

  // sync_queue에 쌓인 변경 사항을 Firestore로 업로드
  Future<void> flushQueue() async {
    status = SyncStatus.syncing;
    notifyListeners();

    try {
      await _syncService.flushQueue(uid);
      status = SyncStatus.synced;
    } catch (_) {
      status = SyncStatus.error;
    }
    notifyListeners();
  }
}
