import 'package:flutter/material.dart';
import 'package:moodleclone/HomePage.dart';

class ImageVerificationScreen extends StatefulWidget {
  final String userMail;
  //final Map<String, dynamic> userType;
  final String userType;

  //final Map<String, dynamic> userData;

  ImageVerificationScreen({required this.userMail,required this.userType});

  @override
  _ImageVerificationScreenState createState() => _ImageVerificationScreenState();
}

class _ImageVerificationScreenState extends State<ImageVerificationScreen> {
  final List<String> allImages = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
    'assets/7.png',
    'assets/8.png',
    'assets/9.png',
  ];

  late List<String> shuffledImages;
  late String targetImage = 'assets/1.png'; // 目標圖片
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    shuffleImages();
  }

  void shuffleImages() {
    shuffledImages = List.from(allImages);
    shuffledImages.shuffle();
  }

  void _verifySelection(String selectedImage) {
    if (selectedImage == targetImage) {
      setState(() {
        isVerified = true;
      });
      // 驗證成功後延遲1秒跳轉到管理頁面
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {

              print('Navigating to HomePage with email: ${widget.userMail}');  // 調試輸出
              return HomePage(
                userMail: widget.userMail,  // 確認這裡有正確傳值
                userType: widget.userType,
              );
            }
          ),
        );
      });
    } else {
      setState(() {
        isVerified = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('選擇錯誤，請重試！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("圖像驗證"),
        // 顯示當前登入用戶
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '用戶: ${widget.userMail}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "請選擇包含",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "220ohm 電阻",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              "的方塊",
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: shuffledImages.length,
                    itemBuilder: (context, index) {
                      final image = shuffledImages[index];
                      return GestureDetector(
                        onTap: () => _verifySelection(image),
                        child: Image.asset(image, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (isVerified)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                    Text(
                      "驗證成功！",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}