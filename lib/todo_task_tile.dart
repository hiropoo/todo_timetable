import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_timetable/todo.dart';

class TodoTaskTile extends StatefulWidget {
  const TodoTaskTile({
    super.key,
    required this.todo,
    required this.todoWasDeleted,
    required this.todoWasTapped,
    required this.todoWasLongPressed,
  });

  final Todo todo;
  final Function(Todo) todoWasDeleted; // Todoが削除されたときのコールバック
  final Function(Todo) todoWasTapped; // Todoがタップされたときのコールバック
  final Function(Todo) todoWasLongPressed; // Todoが長押しされたときのコールバック

  @override
  State<TodoTaskTile> createState() => _TodoTaskTileState();
}

class _TodoTaskTileState extends State<TodoTaskTile> {
  DateTime now = DateTime.now();
  late bool isDone; // チェックボックスの状態

  bool get check => isDone;

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
      child: Slidable(
        key: Key(widget.todo.id),
        startActionPane: ActionPane(
          key: const ValueKey('end'),
          
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                widget.todoWasLongPressed(widget.todo); // Todoを編集
              },
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: '編集',
            ),
          ],
        ),
        endActionPane: ActionPane(
          key: const ValueKey('end'),
          dismissible: DismissiblePane(
            onDismissed: () {
              widget.todoWasDeleted(widget.todo);
            },
          ),
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                widget.todoWasDeleted(widget.todo); // Todoを削除
              },
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '削除',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              // チェックボックスの状態を更新してローカルへ反映 (ローカルの反映はコールバック関数の呼び出し側で行う)
              isDone = !isDone;
            });
            widget.todoWasTapped(widget.todo);
          },
          onLongPress: () {
            // 長押しされた場合はコールバック関数を呼び出す
            // 呼び出す側はコールバック関数を受け取って、Todoの編集を行う
            widget.todoWasLongPressed(widget.todo);
          },
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
                    onChanged: (e) {
                      setState(() {
                        isDone = e ?? false;
                      });
                      widget.todoWasTapped(widget.todo);
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
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
          ),
        ),
      ),
    );
  }
}
