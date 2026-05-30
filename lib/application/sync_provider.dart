import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/sync/sync_service.dart';

enum SyncStatus { synced, syncing, offline, error }

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService;
  final String uid;

  SyncStatus _status = SyncStatus.offline;
  SyncStatus get status => _status;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  bool get isOnline =>
      _status == SyncStatus.synced || _status == SyncStatus.syncing;

  SyncProvider({required SyncService syncService, required this.uid})
      : _syncService = syncService {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _handleConnectivityChange(results);

    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online) {
      _syncOnReconnect();
    } else {
      _status = SyncStatus.offline;
      notifyListeners();
    }
  }

  Future<void> _syncOnReconnect() async {
    _status = SyncStatus.syncing;
    notifyListeners();
    try {
      await _syncService.flushQueue(uid);
      await _syncService.mergeFromFirestore(uid);
      _status = SyncStatus.synced;
    } catch (_) {
      _status = SyncStatus.error;
    }
    notifyListeners();
  }

  // 수동 동기화 (예: pull-to-refresh)
  Future<void> flushQueue() async {
    _status = SyncStatus.syncing;
    notifyListeners();
    try {
      await _syncService.flushQueue(uid);
      _status = SyncStatus.synced;
    } catch (_) {
      _status = SyncStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }
}
