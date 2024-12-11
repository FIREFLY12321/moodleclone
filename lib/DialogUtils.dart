import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogutils{
  static Future<void> showWarning(BuildContext context) {//warning Button
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Not allowed'),
          content: Container(
            height: MediaQuery.of(context).size.height/10, //StorageUtil.getDouble("textScaleFactor"),
            child: Column(
              mainAxisSize: MainAxisSize.min,//將
              children: [
                Text(
                  "Downloading courses in batch is not enabled for this site",
                  style: TextStyle(
                      color: Colors.grey[700],
                  )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('瞭解更多', style: TextStyle(color: Colors.deepOrange)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text('好', style: TextStyle(color: Colors.deepOrange)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 调整圆角的半径
          ),
        );
      },
    );
  }
}