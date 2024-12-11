import 'package:flutter/material.dart';
const List<String> list = <String>['執行中', '未來', '過去', '星號標記','隱藏'];
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 边框颜色
          width: 0.5, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(4.0), //
      ),
      padding: EdgeInsets.symmetric(vertical: 0.1,horizontal: 1),//框框的長寬
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        elevation: 16,
        style: const TextStyle(color: Colors.black),

        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}