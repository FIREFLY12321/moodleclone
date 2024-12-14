import 'package:flutter/material.dart';
import 'package:moodleclone/MemberQuote.dart';
import 'MemberQuote.dart';
class MemberQuoteCard extends StatelessWidget{
  late final MemberQuote quote;
  MemberQuoteCard({quote}){
    this.quote=quote;
  }
  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 15, 10.0, 1.0),//margin邊==版面配置
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,//直接延伸到左邊
            children: <Widget>[
              Text(
                quote.studentID+quote.studentName,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6,),
            ],
          ),
        ),
      ),
    );
  }
}