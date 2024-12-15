import 'package:flutter/material.dart';
import 'Quote.dart';
import 'StudentCoursesMemberChildPage.dart';
class CoursesEditQuoteCard extends StatelessWidget{
  late final Quote quote;
  final Function(String)? onPressed; // 添加回調函數屬性

  CoursesEditQuoteCard({
    required this.quote,
    this.onPressed, // 構造函數中添加可選參數
  });

  Widget build(BuildContext context) {
    return InkWell( // 使用 InkWell 來添加點擊效果
      onTap: () {
        if (onPressed != null) {
          onPressed!(quote.courseCode); // 調用回調函數並傳入課程代碼
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberListPage(courseCode: quote.courseCode),  // 傳入課程代碼
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10.0, 15, 10.0, 1.0),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  quote.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                IconButton(
                    onPressed: (){},//這邊要寫入:編輯課程
                    icon: Icon(Icons.edit),
                ),
                SizedBox(height: 6,),
                IconButton(
                  onPressed: (){},//這邊要寫入:刪除課程
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}