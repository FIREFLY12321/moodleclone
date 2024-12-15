import 'package:flutter/material.dart';
import 'Quote.dart';
import 'StudentCoursesMemberChildPage.dart';
import 'EditCoursesFuture.dart';
import 'DeleteCoursesFuture.dart';


class CoursesEditQuoteCard extends StatelessWidget {
  late final Quote quote;
  final Function(String)? onPressed;
  final Function()? onEdited;  // 添加編輯後的回調

  CoursesEditQuoteCard({
    required this.quote,
    this.onPressed,
    this.onEdited,  // 可選的回調函數
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed!(quote.courseCode);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberListPage(courseCode: quote.courseCode),
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
                  onPressed: () async {
                    final wasEdited = await editCoursesFuture(context, quote);
                    if (wasEdited && onEdited != null) {
                      onEdited!();  // 編輯成功後調用回調
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
                SizedBox(height: 6),
                IconButton(
                  onPressed: () async {
                    final wasDeleted = await deleteCoursesFuture(
                        context,
                        quote.courseCode
                    );
                    if (wasDeleted && onEdited != null) {
                      onEdited!();
                    }
                  },
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