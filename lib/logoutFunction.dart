import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'AuthServiceClass.dart';

Future<void> logout(BuildContext context, AuthService authService) async {
  try {
    // 清除保存的認證信息
    await authService.clearAuthInfo();

    // 確保無法返回之前的頁面（清除導航堆疊）
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  } catch (e) {
    print('登出錯誤: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('登出時發生錯誤'),
        backgroundColor: Colors.red,
      ),
    );
  }
}