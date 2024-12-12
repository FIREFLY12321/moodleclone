import 'package:flutter/material.dart';
import 'BiometricVerification.dart';
import 'login_page.dart';
import 'user_management_page.dart';
import 'auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodle 學習系統',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: LoginPage(),  // 將首頁改為登入頁面
      home:AuthWrapper(),
    );
  }
}
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authInfo = await _authService.getAuthInfo();

    if (authInfo != null) {
      final userType = authInfo['user']['user_type'];
      final userEmail = authInfo['user']['email'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => userType == 'admin'
              ? UserManagementPage(userType: userType, userMail: userEmail)
              : ImageVerificationScreen(userMail: userEmail, userType: userType),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}