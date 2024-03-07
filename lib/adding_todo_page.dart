// スライドアップパネルで表示するウィジェット
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:todo_timetable/todo.dart';
import 'package:uuid/uuid.dart';

class AddingTodoPage extends StatefulWidget {
  const AddingTodoPage({
    super.key,
    required this.panelController,
    required this.className,
    required this.todoIdList,
    required this.todoWasAdded,
  });
  final PanelController panelController;
  final String className;
  final List<String> todoIdList;
  final Function(Todo) todoWasAdded; // Todoが追加されたときのコールバック関数

  @override
  AddingTodoPageState createState() => AddingTodoPageState();
}

class AddingTodoPageState extends State<AddingTodoPage> {
  /* 入力する期限、内容をstateで保存 */
  DateTime _deadline = DateTime.now();
  String _todoContent = "";

  final Map<String, bool> _buttonIsActiveFlags = {
    'pickupButton': false,
    'todayButton': false,
    'tomorrowButton': false,
    'addButton': false,
  };
  bool _dateIsPicked = false; // 一度でも期限が選択されたかどうか

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(height: 15),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                ),
                labelText: "todoを入力してください",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _todoContent = text;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _buttonIsActiveFlags['pickupButton'] = true;
                      _buttonIsActiveFlags['todayButton'] = false;
                      _buttonIsActiveFlags['tomorrowButton'] = false;
                      _buttonIsActiveFlags['addButton'] = true;
                      _dateIsPicked = true;
                    });
                    final result = await showBoardDateTimePicker(
                      context: context,
                      options: const BoardDateTimeOptions(
                          languages: BoardPickerLanguages(
                        locale: 'ja',
                      )),
                      pickerType: DateTimePickerType.datetime,
                    );
                    if (result != null) {
                      setState(() => _deadline = result);
                    }
                  },
                  label: _dateIsPicked
                      ? Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${_deadline.month}/${_deadline.day}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  )),
                              Text("${_deadline.hour}:${_deadline.minute}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ))
                            ],
                          ),
                        )
                      : const Text("期限"),
                  icon: const Icon(Icons.calendar_month),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: const Color.fromARGB(255, 99, 110, 184),
                    elevation:
                        _buttonIsActiveFlags['pickupButton'] == true ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    DateTime now = DateTime.now();
                    setState(() {
                      setState(() {
                        _buttonIsActiveFlags['pickupButton'] = false;
                        _buttonIsActiveFlags['todayButton'] = true;
                        _buttonIsActiveFlags['tomorrowButton'] = false;
                        _buttonIsActiveFlags['addButton'] = true;
                      });
                      _deadline = DateTime(
                          now.year, now.month, now.day, 23, 59, 59, 999);
                    });
                  },
                  label: const Text("今日"),
                  icon: const Icon(Icons.calendar_month),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: const Color.fromARGB(255, 99, 110, 184),
                    elevation:
                        _buttonIsActiveFlags['todayButton'] == true ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _buttonIsActiveFlags['pickupButton'] = false;
                      _buttonIsActiveFlags['todayButton'] = false;
                      _buttonIsActiveFlags['tomorrowButton'] = true;
                      _buttonIsActiveFlags['addButton'] = true;
                    });
                    DateTime tomorrow =
                        DateTime.now().add(const Duration(days: 1));
                    setState(() {
                      _deadline = DateTime(tomorrow.year, tomorrow.month,
                          tomorrow.day, 23, 59, 59, 999);
                    });
                  },
                  label: const Text("明日"),
                  icon: const Icon(Icons.calendar_month),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: const Color.fromARGB(255, 99, 110, 184),
                    elevation:
                        _buttonIsActiveFlags['tomorrowButton'] == true ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(child: SizedBox(width: 10)),
              ElevatedButton(
                onPressed: _buttonIsActiveFlags['addButton'] == true
                    ? () {
                        widget.panelController.close();
                        FocusScope.of(context).unfocus();

                        // Todoインスタンス用のIDを生成
                        const uuid = Uuid();
                        var newId = uuid.v4();
                        // IDに被りがなくなるまで、ループ
                        while (widget.todoIdList.any((id) => id == newId)) {
                          // 被りがあるので、IDを再生成する
                          newId = uuid.v4();
                        }
                        // IDを追加
                        widget.todoIdList.add(newId);

                        // Todoのインスタンスを作成し、コールバック関数の引数としてclassMainPageに渡す
                        Todo newTodo = Todo(
                          isDone: false,
                          content: _todoContent,
                          deadline: _deadline,
                          id: newId,
                        );
                        widget.todoWasAdded(newTodo);

                        // デバッグ用
                        print('todo: $_todoContent');
                        print('deadline: $_deadline');

                        // 変数をリセット
                        _textEditingController.clear();
                        _todoContent = "";
                        _deadline = DateTime.now();
                        _buttonIsActiveFlags['pickupButton'] = false;
                        _buttonIsActiveFlags['todayButton'] = false;
                        _buttonIsActiveFlags['tomorrowButton'] = false;
                        _buttonIsActiveFlags['addButton'] = false;
                        _dateIsPicked = false;
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: const Color.fromARGB(255, 99, 110, 184),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "追加",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.panelController.close();
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: const Color.fromARGB(255, 99, 110, 184),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("閉じる"),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
