import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../config/admin_config.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  AuthService() {
    _initAuthService();
  }

  void _initAuthService() {
    // Firebase Auth 상태 변화 리스너
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        final email = user.email ?? '';
        _currentUser = UserModel(
          id: user.uid,
          email: email,
          name: user.displayName ?? '사용자',
          isAdmin: AdminConfig.isAdminEmail(email),
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // Firebase 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Firebase Authentication으로 사용자 생성
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 사용자 이름 업데이트
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'weak-password':
          _errorMessage = '비밀번호가 너무 약합니다.';
          break;
        case 'email-already-in-use':
          _errorMessage = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          _errorMessage = '올바른 이메일 형식이 아닙니다.';
          break;
        default:
          _errorMessage = '회원가입 중 오류가 발생했습니다: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = '회원가입 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Firebase 로그인
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          _errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          _errorMessage = '올바른 이메일 형식이 아닙니다.';
          break;
        case 'user-disabled':
          _errorMessage = '비활성된 계정입니다.';
          break;
        case 'too-many-requests':
          _errorMessage = '너무 많은 로그인 시도로 일시적으로 차단되었습니다.';
          break;
        default:
          _errorMessage = '로그인 중 오류가 발생했습니다: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = '로그인 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Firebase 로그아웃
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signOut();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '로그아웃 중 오류가 발생했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 비밀번호 재설정 이메일 보내기
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = '등록되지 않은 이메일입니다.';
          break;
        case 'invalid-email':
          _errorMessage = '올바른 이메일 형식이 아닙니다.';
          break;
        default:
          _errorMessage = '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다.';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}