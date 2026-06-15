import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/remote/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = true;
  StreamSubscription<User?>? _sub;

  AuthProvider({required AuthService authService}) : _authService = authService {
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get uid => _user?.uid;
  String? get email => _user?.email;
  String? get displayName => _user?.displayName;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  Future<bool> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      return user != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    _user = null;
    _isLoading = false;
    notifyListeners(); // 스트림 응답 전에 즉시 LoginScreen으로 전환
    await _authService.signOut();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
