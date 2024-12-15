import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Quote.dart';

Future<bool> editCoursesFuture(BuildContext context, Quote quote) async {
  final _titleController = TextEditingController(text: quote.title.split(" - ")[0]);
  final _descriptionController = TextEditingController();
  final _teacherIdController = TextEditingController();
  bool _isLoading = false;
  bool _wasEdited = false;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('編輯課程'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '課程名稱',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '課程描述',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _teacherIdController,
                decoration: const InputDecoration(
                  labelText: '教師ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
              setState(() => _isLoading = true);
              try {
                final response = await http.put(
                  Uri.parse('http://192.168.196.159:8000/courses/${quote.courseCode}'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'teacher_id': int.tryParse(_teacherIdController.text) ?? 0,
                    'course_code': quote.courseCode,
                    'is_active': true,
                  }),
                );

                if (response.statusCode == 200) {
                  _wasEdited = true;
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('課程更新成功')),
                    );
                  }
                } else {
                  throw Exception('更新失敗: ${response.statusCode}');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('錯誤: $e')),
                  );
                }
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('儲存'),
          ),
        ],
      ),
    ),
  );

  return _wasEdited;
}