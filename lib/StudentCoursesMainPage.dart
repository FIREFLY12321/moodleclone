import 'package:flutter/material.dart';
import 'Quote.dart';
import 'QuoteClassCard.dart';
import 'DialogUtils.dart';
import 'DropButton.dart';
import 'Drawer.dart';

class StudentCoursesMainPage extends StatefulWidget {
  const StudentCoursesMainPage({
    super.key,
    required this.title,
    this.userMail,
    this.userType,
  });

  final String title;
  final String? userMail;
  final String? userType;

  @override
  State<StudentCoursesMainPage> createState() => _StudentCoursesMainPageState();
}
class _StudentCoursesMainPageState extends State<StudentCoursesMainPage> {
  //final TextEditingController nameController=new TextEditingController();
  List<Quote>courseList=[
    Quote(title: "113.1【幼保系】GE3909305 高等工程數學 Advanced Engineering Mathematics", semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】BA2800701 幼兒園教材教法-中級會計學 Kindergarten Textbook Teaching Method-Intermediate Accounting",semester:"113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】TC2004701 幼兒園教材教法-微積分教育 Kindergarten Textbook Teaching Method-Calculus Education",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】TCG139301 結構工程力學 Structural Engineering Mechanics",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】MI3002301 資料結構 Data Structures",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】MI3008301 管理數學 Mathematics for Management",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】MI306A001 統計學(上)、MI306A002 統計學(上)",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】MI306A001 嬰幼兒遊戲-CSGO ，Games for babies and toddlers-CSGO",
        semester: "113學年度 第 1 學期"),
    Quote(title:"113.1【幼保系】MI306A001 嬰幼兒性向觀念導正基礎實習、Basic internship on infants and young children’s sexual orientation guidance",
        semester: "113學年度 第 1 學期"),
  ];


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
                              //
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