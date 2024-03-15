// すべてのタスクを表示するページでのみ使用するタスクタイル
// チェックボックスの状態を変更できないようにする
// Todoの授業を表示

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_timetable/todo.dart';

class TodoTaskTileForAllTodoPage extends StatefulWidget {
  const TodoTaskTileForAllTodoPage({
    super.key,
    required this.todo,
  });

  final Todo todo;


  @override
  State<TodoTaskTileForAllTodoPage> createState() => _TodoTaskTileForAllTodoPageState();
}

class _TodoTaskTileForAllTodoPageState extends State<TodoTaskTileForAllTodoPage> {
  DateTime now = DateTime.now();
  late bool isDone; // チェックボックスの状態

  @override
  void initState() {
    super.initState();
    isDone = widget.todo.isDone;
    Timer.periodic(
        const Duration(minutes: 1),
        (Timer t) => setState(() {
              now = DateTime.now(); // 1分ごとに現在時刻を更新
            }));
  }

  @override
  Widget build(BuildContext context) {
    Duration diffTime = widget.todo.deadline.difference(now);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Container(
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
                onChanged: (bool? value) {
                },
                fillColor:
                    MaterialStateProperty.all(const Color(0xFFD0D9D9)),
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
                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            
            // 授業名の表示
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 100, minHeight: 20, maxHeight: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.todo.classColor,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.todo.className,
                    style: const TextStyle(
                      color: const Color(0xFF666666),
                    ),
                  ),
                )
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            if (diffTime.inDays > 0)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("残り${diffTime.inDays}日",
                      style: const TextStyle(color: Color(0xFF666666))),
                ),
              )
            else if (diffTime.inHours > 0)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("残り${diffTime.inHours}時間",
                      style: const TextStyle(color: Color(0xFF666666))),
                ),
              )
            else if (diffTime.inMinutes > 0)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("残り${diffTime.inMinutes}分",
                      style: const TextStyle(color: Color(0xFF666666))),
                ),
              )
            else if (diffTime.inMinutes <= 0 && diffTime.inHours == 0 && diffTime.inDays == 0)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("超過${diffTime.inMinutes.abs()}分",
                      style: const TextStyle(color: Colors.red,)),
                ),
              )
            else if (diffTime.inHours <= 0&& diffTime.inDays == 0)
               ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("超過${diffTime.inHours.abs()}時間",
                      style: const TextStyle(color: Colors.red, )),
                ),
               )
            else if(diffTime.inDays <= 0)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("超過${diffTime.inDays.abs()}日",
                      style: const TextStyle(color: Colors.red,)),
                ),
              ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
