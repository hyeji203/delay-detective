import 'package:flutter/material.dart';

// 지연 태스크에 표시하는 빨간 배지
class DelayedBadge extends StatelessWidget {
  const DelayedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '지연',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
