import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BiometricVerification.dart';
import 'user_management_page.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


//change 12/12
class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();

  //important//

  final _formKey            = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _isLoading          = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('嘗試登入 - Email: ${_usernameController.text}');

      final response = await http.post(
        Uri.parse('http://192.168.196.159:8000/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'grant_type': 'password',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);
      // 登入成功
      if (response.statusCode == 200) {
        //這邊站存使用者登入權杖
        await _authService.saveAuthInfo(responseData);
        // await 關鍵字來等待方法執行完成後再繼續執行後續代碼。

        final userType = responseData['user']['user_type'];
        // 根據用戶類型導航到不同頁面
        if (userType == 'admin') {
          print(responseData);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserManagementPage(
                userType: userType,
                userMail: _usernameController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('登入成功！'),
              backgroundColor: Colors.green,
            ),
          );
          // 延遲0.5秒後導航到生物辨識頁面
          Timer(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ImageVerificationScreen(
                  userMail: _usernameController.text, // 假設 API 回傳中包含 email
                  userType: "student", // 傳遞整個使用者資料物件
                ),
              ),
            );
          });
        }
      } else {
        // 處理不同類型的錯誤
        String errorMessage;
        Color errorColor;

        switch(responseData['error_type']) {
          case 'email_not_found':
            errorMessage = '此電子郵件尚未註冊';
            errorColor = Colors.orange;
            break;
          case 'wrong_password':
            errorMessage = '密碼錯誤';
            errorColor = Colors.red;
            break;
          default:
            errorMessage = '登入失敗';
            errorColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: errorColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('登入錯誤: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登入失敗：請檢查網路連接'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登入'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,  // 設置鍵盤類型為電子郵件
                    decoration: InputDecoration(
                        labelText: '電子郵件',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'example@example.com'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請輸入電子郵件';
                      }
                      // 檢查電子郵件格式
                      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return '請輸入有效的電子郵件地址';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '密碼',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請輸入密碼';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('登入'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}