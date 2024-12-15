import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'CourseQuote.dart';
import 'CoursesEditQuoteCard.dart';
import 'Quote.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({Key? key}) : super(key: key);

  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}


class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  List<Quote> _courses = [];
  bool _isLoadingCourses = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }
  Future<List<Quote>> fetchAllCourses(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.196.159:8000/courses/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          return (data['courses'] as List).map((courseData) => Quote(
            title: courseData['title'] +
                " " +
                courseData['teacher_name'] ?? '',
            semester: "113.1", // 可以從 API 獲取或設定默認值
            courseCode: courseData['course_code'] ?? '',
          )).toList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('獲取課程列表失敗'),
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
  // 在課程列表頁面使用
  Future<void> _loadCourses() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.196.159:8000/courses/'));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          setState(() {
            // 使用 CourseQuote
            _courses = (data['courses'] as List)
                .map((json) => CourseQuote.fromJson(json))
                .toList();
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// 在 UI 中使用
  Widget buildCourseCard(Quote quote) {
    if (quote is CourseQuote) {
      // 使用 CourseQuote 特有的屬性
      return Card(
        child: ListTile(
          title: Text(quote.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教師: ${quote.teacherName ?? "未指定"}'),
              if (quote.description != null)
                Text('描述: ${quote.description}'),
            ],
          ),
        ),
      );
    } else if (quote is StudentQuote) {
      // 使用 StudentQuote 特有的屬性
      return Card(
        child: ListTile(
          title: Text(quote.title),
          subtitle: quote.enrollmentDate != null
              ? Text('註冊日期: ${quote.enrollmentDate!.toString()}')
              : null,
        ),
      );
    }

    // 基礎 Quote 的顯示
    return Card(
      child: ListTile(
        title: Text(quote.title),
        subtitle: Text(quote.courseCode),
      ),
    );
  }


  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.196.159:8000/courses/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': _titleController.text,
          'course_code': _codeController.text,
          'description': _descriptionController.text,
          'teacher_id': int.parse(_teacherIdController.text),
          'is_active': true,
        }),
      );

      if (!mounted) return;

      // 解碼響應內容
      final responseData = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? '課程創建成功！')),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _errorMessage = responseData['detail'] ?? '創建課程失敗';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '網路錯誤: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('創建新課程'),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '課程名稱',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入課程名稱';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: '課程代碼',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入課程代碼';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _teacherIdController,
                        decoration: const InputDecoration(
                          labelText: '教師ID',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入教師ID';
                          }
                          if (int.tryParse(value) == null) {
                            return '請輸入有效的數字ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '課程描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _isLoading ? null : _createCourse,
                            child: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text('創建課程',style: TextStyle(color: Colors.black),),
                          ),
                          Spacer(),
                          //SizedBox(height: 16,),
                          ElevatedButton(

                            onPressed: _isLoading ? null : (){
                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CourseListPage(),
                                ),
                              );*/
                            },//
                            child: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text('列出課程',style: TextStyle(color: Colors.black),),
                          ),

                        ],
                      ),
                      // 右側課程列表


                    ],
                  ),
                ),
              ),
          ),
      Expanded(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey),
            ),
          ),
          child: _isLoadingCourses
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadCourses,
                  child: const Text('重新載入'),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: _loadCourses,
            child: _courses.isEmpty
                ? const Center(child: Text('暫無課程數據'))
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                return CoursesEditQuoteCard(
                  quote: _courses[index],
                  onPressed: (courseCode) async {
                    // 處理課程點擊
                  },
                );
              },
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _teacherIdController.dispose();
    super.dispose();
  }
}