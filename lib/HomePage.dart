import 'package:flutter/material.dart';
import 'dart:async';
import 'StudentCoursesMainPage.dart';

class HomePage extends StatefulWidget {
  final String userType;
  final String userMail;
  const HomePage({
    Key? key,
    required this.userMail,  // 標記為必需的
    required this.userType,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 延遲 0.5 秒後導航到學生課程主頁
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentCoursesMainPage(
            title: '學生課程主頁',
            // 如果 MyHomePage 需要用戶資訊，可以在這裡傳遞
            userMail: widget.userMail,
            userType: widget.userType,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首頁'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                '登入成功！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('用戶資訊：',
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 10),
                      Text('電子郵件: ${widget.userMail}'),
                      Text('用戶類型: ${widget.userType}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}