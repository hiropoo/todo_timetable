import 'package:flutter/material.dart';

class ClassOptionDialog extends StatefulWidget {
  const ClassOptionDialog({super.key});

  @override
  State<ClassOptionDialog> createState() => _ClassOptionDialogState();
}

class _ClassOptionDialogState extends State<ClassOptionDialog> {
  final TextEditingController _classNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFBFBFB),
      surfaceTintColor: Colors.transparent, // backgroundColorを適用するために必要
      title: const Padding(
        padding:  EdgeInsets.only(left: 10),
        child:  Text(
          '授業を追加',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666)),
        ),
      ),
      content: TextFormField(
        cursorColor: Colors.grey[600],
        controller: _classNameController,
        autofocus: true,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xff666666),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 99, 110, 184),
              width: 1.5,
            ),
          ),
          labelText: "授業名を入力してください",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
          child: const Text('キャンセル', style: TextStyle(color: Color(0xFF666666))),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_classNameController.text);
          },
          child: const Text('保存', style: TextStyle(color: Color.fromARGB(255, 99, 110, 184))),
        ),
      ],
    );
  }
}
