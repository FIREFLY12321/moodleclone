import 'dart:convert';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import 'Quote.dart';
import 'QuoteClassCard.dart';
import 'DialogUtils.dart';
import 'DropButton.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading=false;
  Future<List<Quote>> fetchStudentCourses(String email, BuildContext context) async {
    try {
      // 使用 ScaffoldMessenger 顯示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('正在獲取課程，Mail: $email'),
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
            title     :
                        "113.1"                 +
                        " "                     +
                        courseData['courseCode']+
                        " "                     +
                        courseData['title'     ]+
                        " "                     +
                        courseData['teacher'   ],

            semester  : courseData['semester'  ],
            courseCode: courseData['courseCode'],  // 直接傳入 courseCode
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
      _loadCourses2();  // 新的加載函數
    });
  }
  // 新增加載函數
  Future<void> _loadCourses2() async {
    try {
      setState(() {
        isLoading = true;  // 添加狀態標記
      });
      if (widget.userMail != null) {
        final courses = await fetchStudentCourses(widget.userMail!, context);
        if (mounted) {
          setState(() {
            courseList = courses;
            isLoading  = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加載課程失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
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
                  onPressed: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
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
                    SizedBox(height: 3.0),
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
                              _scaffoldKey.currentState?.openEndDrawer();
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
      endDrawer: CustomDrawer(), // 使用外部定義的 Drawer
    );
  }
}
