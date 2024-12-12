import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'Quote.dart';
import 'QuoteClassCard.dart';
import 'DialogUtils.dart';
import 'DropButton.dart';
import 'package:http/http.dart' as http;
import 'Drawer.dart';

class StudentCoursesMainPage extends StatefulWidget {
  const StudentCoursesMainPage({
    super.key,
    required this.title,
    this.userMail,
    this.userType,
  });

  final String  title;
  final String? userMail;
  final String? userType;

  @override
  State<StudentCoursesMainPage> createState() => _StudentCoursesMainPageState();
}
class _StudentCoursesMainPageState extends State<StudentCoursesMainPage> {
  List<Quote> courseList = [];
  // 從 email 獲取學號的輔助函數
  String getStudentIdFromEmail(String email) {
    return email.split('@')[0];  // 取 @ 符號前的部分作為學號
  }
  Future<List<Quote>> fetchStudentCourses(String email, BuildContext context) async {
    try {
      // 使用 ScaffoldMessenger 顯示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('正在獲取課程，用戶郵箱: $email'),
          duration: Duration(seconds: 3),
        ),
      );

      final response = await http.get(
        Uri.parse('http://192.168.196.159:8000/student/courses/$email'),
      );

      // 顯示 API 響應狀態
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('API響應狀態: ${response.statusCode}'),
          duration: Duration(seconds: 2),
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return (data['courses'] as List).map((courseData) => Quote(
            title: courseData['title'],
            semester: courseData['semester'],
          )).toList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('API返回錯誤: ${data['message']}'),
              backgroundColor: Colors.red,
            ),
          );
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('HTTP請求失敗: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('發生錯誤: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return [];
    }
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 彈出對話框顯示 userMail 的值
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('用戶信息'),
            content: Text(widget.userMail ?? '沒有收到用戶郵箱'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // 如果有郵箱，則繼續獲取課程
                  if (widget.userMail != null) {
                    fetchStudentCourses(widget.userMail!, context).then((courses) {
                      setState(() {
                        courseList = courses;
                      });
                    });
                  }
                },
                child: Text('確定'),
              ),
            ],
          );
        },
      );
    });
  }


  // 載入學生課程的函數
  Future<void> loadStudentCourses(String email) async {
    final studentId = getStudentIdFromEmail(email);

    // 數據庫查詢 SQL：
    final sql = '''
    SELECT 
      c.title,
      c.course_code,
      t.full_name AS teacher_name,
      ce.enrollment_date,
      c.description
    FROM courses c
    JOIN course_enrollments ce ON c.course_id = ce.course_id
    JOIN users s ON ce.user_id = s.user_id
    JOIN users t ON c.teacher_id = t.user_id
    WHERE s.student_id = ?
    ORDER BY ce.enrollment_date DESC
  ''';
    try {
      // 執行查詢（這裡需要根據你的數據庫連接方式來實現）
      // var results = await db.query(sql, [studentId]);

      setState(() {
        courseList.clear();  // 清空現有列表

        // 將查詢結果轉換為 Quote 對象並添加到列表中
        // for (var row in results) {
        //   courseList.add(Quote(
        //     title: "${row['course_code']} ${row['title']}",
        //     semester: "目前學期",  // 可以從數據庫中添加學期信息
        //   ));
        // }
      });
    } catch (e) {
      print('Error loading courses: $e');
      // 可以添加錯誤處理邏輯，比如顯示提示框
    }
  }

  Widget quoteClassTemplate({quote}){
    return new QuoteClassCard(quote:quote);
  }
  final TextEditingController myController = new TextEditingController();
  void _incrementCounter() {
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer 定義在這裡
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // 處理點擊事件
                Navigator.pop(context); // 關閉 drawer
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // 處理點擊事件
                Navigator.pop(context); // 關閉 drawer
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 10.0),
                const Text(
                  '臺灣科技大學Moodle教學平台',
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                TextButton(
                  onPressed: () =>Scaffold.of(context).openDrawer(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/head.png",
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
                //here==========================================
              ],
            ),
          ),
          Expanded( // 使用 Expanded 来占用剩余空间
            child: SingleChildScrollView( // 包装一个可滚动的视窗
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height:0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "我的課程",
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => Dialogutils.showWarning(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/cloudDownload.png",
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      height: 35,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '過濾我的課程',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonExample(),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.align_horizontal_right_rounded),
                            onPressed: () {
                              //                                                 todo::   func that modify users profile picture
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: courseList.map((quote) {
                        return quoteClassTemplate(
                          quote: quote,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
