import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_timetable/todo.dart';

class TodoTaskTile extends StatefulWidget {
  const TodoTaskTile({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoTaskTile> createState() => _TodoTaskTileState();
}

class _TodoTaskTileState extends State<TodoTaskTile> {
  DateTime now = DateTime.now();
  bool isDone = false; // チェックボックスの状態

  bool get check => isDone;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
        const Duration(minutes: 1),
        (Timer t) => setState(() {
              now = DateTime.now(); // 1分ごとに現在時刻を更新
            }));

    // データベースに登録されているタスクの状態を取得
  }

  @override
  Widget build(BuildContext context) {
    Duration diffTime = widget.todo.deadline.difference(now);

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              value: isDone,
              side: const BorderSide(width: 1, color: Color(0xFFD0D9D9)),
              onChanged: (e) {
                setState(() {
                  isDone = e ?? false;
                });
                // データベースに登録されているタスクの状態を更新
              },
              fillColor: MaterialStateProperty.all(const Color(0xFFD0D9D9)),
              checkColor: const Color(0xFF9FA7DA),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.todo.content,
              style: TextStyle(
                color: const Color(0xFF666666),
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (diffTime.inDays > 0)
            Text("残り${diffTime.inDays}日",
                style: const TextStyle(color: Color(0xFF666666)))
          else if (diffTime.inHours > 0)
            Text("残り${diffTime.inHours}時間",
                style: const TextStyle(color: Color(0xFF666666)))
          else if (diffTime.inMinutes > 0)
            Text("残り${diffTime.inMinutes}分",
                style: const TextStyle(color: Color(0xFF666666))),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
