import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  final Map<String, Map<String, dynamic>> _mockDatabase = {};

  AuthService() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('currentUser');
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        _currentUser = UserModel.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Failed to load user from storage: $e');
    }
  }

  Future<void> _saveUserToStorage(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUser', jsonEncode(user.toJson()));
    } catch (e) {
      print('Failed to save user to storage: $e');
    }
  }

  Future<void> _clearUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
    } catch (e) {
      print('Failed to clear user from storage: $e');
    }
  }

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
      await Future.delayed(const Duration(seconds: 1));

      if (_mockDatabase.containsKey(email)) {
        _errorMessage = '이미 등록된 이메일입니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final newUser = UserModel(
        id: userId,
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      _mockDatabase[email] = {
        'password': password,
        'user': newUser.toJson(),
      };

      _currentUser = newUser;
      await _saveUserToStorage(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '회원가입 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!_mockDatabase.containsKey(email)) {
        _errorMessage = '등록되지 않은 이메일입니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userData = _mockDatabase[email]!;
      if (userData['password'] != password) {
        _errorMessage = '비밀번호가 올바르지 않습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = UserModel.fromJson(userData['user']);
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());

      _mockDatabase[email]!['user'] = updatedUser.toJson();
      _currentUser = updatedUser;
      await _saveUserToStorage(updatedUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '로그인 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      await _clearUserFromStorage();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '로그아웃 중 오류가 발생했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}