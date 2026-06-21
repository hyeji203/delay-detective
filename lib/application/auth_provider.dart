import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/remote/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = true;
  bool _demoMode = false;
  StreamSubscription<User?>? _sub;

  AuthProvider({required AuthService authService}) : _authService = authService {
    // URL ?demo=1 파라미터로 자동 데모 모드 진입 (로그인 우회)
    if (kIsWeb && Uri.base.queryParameters.containsKey('demo')) {
      _demoMode = true;
      _isLoading = false;
    }
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (_demoMode) return; // 데모 모드일 때는 Firebase 상태 무시
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get uid => _user?.uid ?? (_demoMode ? 'demo' : null);
  String? get email => _user?.email;
  String? get displayName => _user?.displayName ?? (_demoMode ? '데모 사용자' : null);
  bool get isLoggedIn => _user != null || _demoMode;
  bool get isLoading => _isLoading;
  bool get isDemoMode => _demoMode;

  void loginAsDemo() {
    _demoMode = true;
    _isLoading = false;
    notifyListeners();
  }

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
