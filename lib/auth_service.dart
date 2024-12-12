import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<void> saveAuthInfo(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(responseData['user']));
    await prefs.setBool(_isLoggedInKey, true);
    // 如果有 token 也保存
    if (responseData['access_token'] != null) {
      await prefs.setString(_tokenKey, responseData['access_token']);
    }
  }

  Future<Map<String, dynamic>?> getAuthInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final token = prefs.getString(_tokenKey);

    if (!isLoggedIn || userStr == null) {
      return null;
    }

    return {
      'user': json.decode(userStr),
      'isLoggedIn': isLoggedIn,
      'token': token,
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}