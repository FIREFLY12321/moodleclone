import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // 清除所有認證信息
  Future<void> clearAuthInfo() async {
    try {
      // 清除所有保存的認證相關信息
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'token_type');
      await _storage.delete(key: 'user_type');
      await _storage.delete(key: 'user_id');
      await _storage.delete(key: 'email');
      await _storage.delete(key: 'full_name');

      // 如果有其他需要清除的認證信息，也在這裡添加

      print('認證信息清除成功');
    } catch (e) {
      print('清除認證信息時發生錯誤: $e');
      throw Exception('清除認證信息失敗');
    }
  }
}