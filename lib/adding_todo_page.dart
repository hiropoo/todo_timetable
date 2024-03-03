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
    required this.todoList,
    required this.className,
    required this.todoIdList,
  });
  final PanelController panelController;
  final List<Todo> todoList;
  final String className;
  final List<String> todoIdList;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    // ローカルからTodoListを読み込む
    // loadTodo().then((loadedTodoList) {
    //   setState(() {
    //     todoList = loadedTodoList;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
        onTap: () {
          // FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
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
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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

                        // IDを生成
                        const uuid = Uuid();
                        var newId = uuid.v4();
                        // IDに被りがなくなるまで、ループ
                        while (widget.todoIdList.any((id) => id == newId)) {
                          // 被りがあるので、IDを再生成する
                          newId = uuid.v4();
                        }
                        // IDを追加
                        widget.todoIdList.add(newId);

                        // TodoTaskTileを追加
                        Todo newTodo = Todo(
                          isDone: false,
                          content: _todoContent,
                          deadline: _deadline,
                          id: newId,
                        );
                        widget.todoList.add(newTodo);

                        // TodoListをローカルに保存
                        // saveTodo();

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

//   // TodoListをローカルに保存するメソッド
//   Future saveTodo() async {
//     // TodoListをjson形式のリストに変換
//     List<String> todoListJson = todoList.map((todo) {
//       return json.encode(todo.toJson());
//     }).toList();

//     // SharedPreferencesに保存
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setStringList(
//         '${widget.className}_todoList', todoListJson); // todoListを保存

//     print('todoListを保存しました. todoList: $todoListJson');
//   }

// // TodoListをローカルから読み込むメソッド
//   Future<List<Todo>> loadTodo() async {
//     final prefs = await SharedPreferences.getInstance();
//     final todoListJson =
//         prefs.getStringList('${widget.className}_todoList') ?? [];

//     // json形式のリストをTodoListに変換
//     List<Todo> todoList = todoListJson.map((todoJson) {
//       return Todo.fromJson(json.decode(todoJson));
//     }).toList();

//     print('todoListを読み込みました. todoList: $todoList');

//     return todoList;
//   }

//   Future saveTodo({required Todo todo, required String className}) async {
//     final directory = await getApplicationCacheDirectory();
//     final path = '${directory.path}/${className}_todo.json';
//     final file = File(path);
//     print('出力パス = $path');

// // String型に変換して保存
//     final jsonString = json.encode(todo.toJson());
//     file.writeAsStringSync(jsonString);
//     print('書き込み内容 = $jsonString');
//   }

// // TodoListをローカルから読み込むメソッド
//   Future<List<Todo>> loadTodoList(
//       {required Todo todo, required String className}) async {
//     final directory = await getApplicationCacheDirectory();
//     final path = '${directory.path}/${className}_todo.json';
//     final file = File(path);
//     print('読み込みパス = $path');

//     final jsonString = file.readAsStringSync();
//     print('読み込み内容 = $jsonString');

//     final todo = Todo.fromJson(json.decode(jsonString));
//     print('読み込み内容 = $todo');

//     return [todo];
//   }
}
