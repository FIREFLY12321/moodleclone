import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'MemberQuote.dart';
import 'MemberQuoteCard.dart';

class MemberListPage extends StatefulWidget {
  final String courseCode;  // 添加課程代碼屬性
  MemberListPage({required this.courseCode});
  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

/*
class _MemberListPageState extends State<MemberListPage> {
  // 修改構造函數
  @override
  _MemberListPageState createState() => _MemberListPageState();

  final List<MemberQuote> members = [
    MemberQuote(studnetID: "D1094182", studentName: "王小明"),

    // 可以繼續添加更多測試數據
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('成員列表'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // 設置背景顏色
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(), // 增加彈性滾動效果5
          itemCount: members.length,
          itemBuilder: (context, index) {
            return MemberQuoteCard(quote: members[index]);
          },
        ),
      ),
    );
  }
}
*/
class _MemberListPageState extends State<MemberListPage> {
  List<MemberQuote> members = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.196.159:8000/course-members/${widget.courseCode}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            members = (data['members'] as List).map((memberData) =>
                MemberQuote(
                    studnetID: memberData['student_id'],
                    studentName: memberData['full_name']
                )
            ).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            error = '獲取數據失敗';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = '伺服器錯誤';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading members: $e');
      setState(() {
        error = '網絡連接錯誤';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.courseCode} 成員列表'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: members.length,
          itemBuilder: (context, index) {
            return MemberQuoteCard(quote: members[index]);
          },
        ),
      ),
    );
  }
}