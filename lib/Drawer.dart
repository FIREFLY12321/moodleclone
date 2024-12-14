import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AuthServiceClass.dart';
import 'logoutFunction.dart';

class CustomDrawer extends StatelessWidget {
  // 在 State 類頂部先宣告 AuthService
  final _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white, // 改為藍色背景，讓文字清晰可見
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 內容左對齊
              mainAxisAlignment: MainAxisAlignment.center, // 內容垂直居中
              children: [
                Text(
                  '用戶帳號',
                  style: TextStyle(
                    color: Colors.black, // 顏色改為白色，與背景對比
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '臺灣科技大學Moodle教學平台',
                  style: TextStyle(
                    color: Colors.black, // 顏色改為白色，保持一致
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'https://moodle2.ntust.edu.tw',
                  style: TextStyle(
                    color: Colors.blue, // 顯眼的顏色，與背景對比
                    fontSize: 14,
                    decoration: TextDecoration.underline, // 顯示連結樣式
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file, color: Colors.grey[800]), // 圖標顏色設置為藍色
            title: Text('成績'),
            onTap: () {
              Navigator.pop(context); // 關閉側拉視窗
            },
          ),
          ListTile(
            leading: Icon(Icons.folder, color: Colors.grey[800]), // 圖標顏色設置為藍色
            title: Text('檔案'),
            onTap: () {
              Navigator.pop(context); // 關閉側拉視窗
            },
          ),
          ListTile(
            leading: Icon(Icons.pageview_rounded, color: Colors.grey[800]), // 圖標顏色設置為藍色
            title: Text('報表'),
            onTap: () {
              Navigator.pop(context); // 關閉側拉視窗
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[800]), // 圖標顏色設置為藍色
            title: Text('部落格文章'),
            onTap: () {
              Navigator.pop(context); // 關閉側拉視窗
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // 登出按鈕的邏輯
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('確認登出'),
                      content: Text('您確定要登出嗎？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 關閉對話框


                          },
                          child: Text('取消'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // 模擬登出後的動作
                            Navigator.pop(context); // 關閉側拉視窗
                            // 在這裡可以添加登出邏輯
                            logout(context,_authService);//需要兩格參數
                            //
                          },
                          child: Text('確定'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.logout,color: Colors.white,),
              label: Text(
                  '登出',
                  style: TextStyle(
                    color: Colors.white,
                  ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 按鈕背景顏色設置為紅色
              ),
            ),
          ),
        ],
      ),
    );
  }
}
