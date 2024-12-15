// lib/utils/course_utils.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<bool> deleteCoursesFuture(BuildContext context, String courseCode) async {
  bool wasDeleted = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('確認刪除'),
      content: const Text('確定要刪除這個課程嗎？這個操作無法撤銷。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            '刪除',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.196.159:8000/courses/$courseCode'),
      );

      if (response.statusCode == 200) {
        wasDeleted = true;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('課程已刪除')),
          );
        }
      } else {
        throw Exception('刪除失敗: ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('錯誤: $e')),
        );
      }
    }
  }

  return wasDeleted;
}