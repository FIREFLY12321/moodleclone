import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Drawer.dart';
import 'StudentCoursesMainPage.dart';

class UserManagementPage extends StatefulWidget {
  final String userMail;
  final String userType;
  UserManagementPage({required this.userMail, required this.userType});
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController       = TextEditingController();
  final _emailController          = TextEditingController();
  final _passwordController       = TextEditingController();
  final _fullNameController       = TextEditingController();
  final _studentIdController      = TextEditingController();
  final _editEmailController      = TextEditingController();
  final _editFullNameController   = TextEditingController();
  final _editStudentIdController  = TextEditingController();
  List<dynamic> users = [];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    fetchUsers();

    // 每5秒更新一次
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchUsers();
    });
  }
  void navigateToCoursePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentCoursesMainPage(
              title: '學生課程主頁',
              userMail: widget.userMail,
              userType: widget.userType,
            ),
      ),
    );
  }
  // 獲取用戶列表
  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.196.159:8000/users/'));
      if (response.statusCode == 200) {
        //改為解碼一次
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = json.decode(decodedBody);
        //NEW 1211

        setState(() {
          users =responseData;
        });
        // 如果需要印出 message
        print(responseData['message']);
      }else {
        print('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // dispose() 方法應該在類別中單獨定義 1211
  @override
  void dispose() {
    _timer?.cancel(); // 記得取消定時器
    super.dispose();
  }


  // 創建新用戶
  Future<void> createUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.196.159:8000/users/'),
        headers: {'Content-Type': 'application/json'}  ,
        body: json.encode({
          'username':   _usernameController.text ,
          'email':      _emailController.text    ,
          'password':   _passwordController.text ,
          'full_name':  _fullNameController.text ,
          'user_type':  'student'                ,
          'student_id': _studentIdController.text,
        }),
      );
      print('Request body: ${json.encode({
        'username':   _usernameController.text  ,
        'email':      _emailController.text     ,
        'password':   _passwordController.text  ,
        'full_name':  _fullNameController.text  ,
        'user_type': 'student',
        'student_id': _studentIdController.text ,
      })}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('驗證錯誤: ${errorData['detail']}')),
        );
        return;
      }

      if (response.statusCode == 200) {
        fetchUsers();  // 重新載入用戶列表
        clearForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('用戶創建成功')),
        );
      }
    }  catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('創建用戶失敗: $e')),
      );
    }
  }

  // 刪除用戶
  Future<void> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.196.159:8000/users/$userId'),
      );

      if (response.statusCode == 200) {
        fetchUsers();  // 重新載入用戶列表
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('用戶刪除成功')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('刪除用戶失敗: $e')),
      );
    }
  }
  // 編輯用戶方法
  Future<void> _showEditDialog(Map<String, dynamic> user) async {
    _editEmailController.text = user['email'];
    _editFullNameController.text = user['full_name'];
    _editStudentIdController.text = user['student_id'] ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('編輯用戶'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editEmailController,
                decoration: InputDecoration(labelText: '電子郵件'),
              ),
              TextField(
                controller: _editFullNameController,
                decoration: InputDecoration(labelText: '全名'),
              ),
              TextField(
                controller: _editStudentIdController,
                decoration: InputDecoration(labelText: '學號'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await updateUser(user['user_id']);
              Navigator.of(context).pop();
            },
            child: Text('保存'),
          ),
        ],
      ),
    );
  }
  // 更新用戶方法
  Future<void> updateUser(int userId) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.196.159:8000/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _editEmailController.text,
          'full_name': _editFullNameController.text,
          'student_id': _editStudentIdController.text,
        }),
      );

      if (response.statusCode == 200) {
        fetchUsers();  // 更新列表
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('用戶更新成功')),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失敗: ${errorData['detail']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新失敗: $e')),
      );
    }
  }

  void clearForm() {
    _usernameController .clear();
    _emailController    .clear();
    _passwordController .clear();
    _fullNameController .clear();
    _studentIdController.clear();  // 清除學號
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('用戶管理'),
      ),
      body: SingleChildScrollView(
        child: Padding(


          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(

                onPressed: (){
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                icon: Icon(Icons.settings),

              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: '用戶名'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入用戶名';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _studentIdController,
                      decoration: InputDecoration(labelText: '學號'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入學號';
                        }
                        // 驗證學號格式
                        if (!RegExp(r'^[A-Za-z]\d{8}$').hasMatch(value)) {
                          return '學號格式必須為一個英文字母加上八位數字';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: '電子郵件'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入電子郵件';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: '密碼'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入密碼';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(labelText: '全名'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入全名';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createUser();
                        }
                      },
                      child: Text('創建用戶'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text('用戶列表', style: Theme.of(context).textTheme.titleLarge),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['username']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['email']),
                        Text('學號: ${user['student_id'] ?? "無"}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // 顯示編輯對話框
                            _showEditDialog(user);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteUser(user['user_id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      endDrawer: CustomDrawer(), // 使用外部定義的 Drawer
    );
  }
}