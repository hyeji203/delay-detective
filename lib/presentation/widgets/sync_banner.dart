import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/sync_provider.dart';

// 화면 상단에 동기화 상태를 표시하는 배너
class SyncBanner extends StatelessWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SyncProvider>().status;

    return switch (status) {
      SyncStatus.syncing => const _BannerTile(
          color: Colors.blue,
          icon: Icons.sync,
          message: '동기화 중...',
        ),
      SyncStatus.offline => const _BannerTile(
          color: Colors.grey,
          icon: Icons.wifi_off,
          message: '오프라인 — 변경 사항은 연결 후 동기화돼요',
        ),
      SyncStatus.error => const _BannerTile(
          color: Colors.orange,
          icon: Icons.warning,
          message: '동기화 실패 — 잠시 후 재시도',
        ),
      SyncStatus.synced => const SizedBox.shrink(),
    };
  }
}

class _BannerTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String message;

  const _BannerTile({
    required this.color,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
