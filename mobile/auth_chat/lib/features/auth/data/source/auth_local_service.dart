import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';

abstract class AuthLocalService {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearAuth();
  Future<bool> isLoggedIn();
}

class AuthLocalServiceImpl implements AuthLocalService {
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  @override
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
} 