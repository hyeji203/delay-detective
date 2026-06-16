import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/auth_provider.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final initial = (auth.displayName?.isNotEmpty == true
            ? auth.displayName![0]
            : auth.email?.isNotEmpty == true
                ? auth.email![0]
                : '?')
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _showProfileSheet(context, auth),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF3F51B5),
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF3F51B5),
              child: Text(
                (auth.displayName?.isNotEmpty == true
                        ? auth.displayName![0]
                        : auth.email?[0] ?? '?')
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (auth.displayName != null)
              Text(
                auth.displayName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            if (auth.email != null)
              Text(
                auth.email!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9EAE),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await auth.signOut();
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF5350),
                  side: const BorderSide(color: Color(0xFFEF5350)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
