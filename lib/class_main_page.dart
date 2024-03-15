// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_timetable/all_todo_list.dart';
import 'package:todo_timetable/todo.dart';
import 'package:todo_timetable/todo_add_page.dart';
import 'package:todo_timetable/todo_edit_page.dart';
import 'package:todo_timetable/todo_task_tile.dart';

class ClassMainPage extends ConsumerStatefulWidget {
  final String className; // 授業名
  final Color color; // 画面の色

  const ClassMainPage(
      {super.key, required this.className, required this.color});

  @override
  ClassMainPageState createState() => ClassMainPageState();
}

class ClassMainPageState extends ConsumerState<ClassMainPage> {
  // ignore: unused_field
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final PanelController _panelController = PanelController();
  bool _isVisible = true;
  final List<Todo> _todoList = []; // Todoリスト
  // タスクIDリスト (static にすることで教科を跨いでID情報を共有)
  static final List<String> todoIdList = [];

  Map<DateTime?, List<String>> todoEvents = {}; // カレンダーのイベント(TodoのIDを保存)

  bool _isEditing = false; // 編集モードかどうか　=> スライドアップパネルを切り替えるためのフラグ
  GlobalObjectKey? todoEditKey;

  @override
  void initState() {
    super.initState();
    // 起動時にTodoListを読み込む
    // todoEventsを更新する際に_todoListが必要なため、
    // loadTodo()の後にloadTodoEvents()を呼び出す
    loadTodo().then((value) {
      sortTodoByDeadline();
      loadTodoEvents();
    });
  }

  // SharedPreferencesからTodoListを読み込むメソッド
  Future loadTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final todoListJson =
        prefs.getStringList('${widget.className}_todoList') ?? [];

    // json形式のリストをTodoListに変換
    List<Todo> todoList = todoListJson.map((todoJson) {
      return Todo.fromJson(json.decode(todoJson));
    }).toList();

    // Todoリストを更新
    setState(() {
      _todoList.clear();
      _todoList.addAll(todoList);
    });
  }

  // TodoListからTodoのイベントを読み込むメソッド
  void loadTodoEvents() {
    todoEvents.clear();
    for (Todo todo in _todoList) {
      DateTime? utcDate = todo.deadline.toUtc();
      int utcYear = utcDate.year;
      int utcMonth = utcDate.month;
      int utcDay = utcDate.day;
      utcDate = DateTime.utc(utcYear, utcMonth, utcDay);

      if (todoEvents[utcDate] == null) {
        todoEvents[utcDate] = [todo.id];
      } else {
        todoEvents[utcDate]?.add(todo.id);
      }
    }
    print('todoEvents: $todoEvents'); // デバッグ用
  }

  // SharedPreferencesに更新されたTodoListを保存するメソッド
  Future saveTodo() async {
    // TodoListをjson形式のリストに変換
    List<String> todoListJson = _todoList.map((todo) {
      return json.encode(todo.toJson());
    }).toList();

    // SharedPreferencesに保存
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        '${widget.className}_todoList', todoListJson); // todoListを保存

    setState(() {}); // 画面を更新
  }

  /// todoListをTodoのリストを残り時間でソートするメソッド
  void sortTodoByDeadline() {
    _todoList.sort((a, b) => a.deadline.compareTo(b.deadline));
    saveTodo();
  }

  // カレンダーの日付のテキストカラーを変えるメソッド(土: 青, 日: 赤, 他: 黒)
  Color _textColor(DateTime day) {
    const defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return defaultTextColor;
  }

  @override
  Widget build(BuildContext context) {
    todoEditKey = GlobalObjectKey<TodoEditPageState>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF666666))),
      ),
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        backdropEnabled: true,
        controller: _panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.3,

        // fab がスライドアップパネルに重ならないようにするための設定
        onPanelSlide: (position) {
          if (_panelController.isPanelOpen) {
            setState(() {
              _isVisible = false;
            });
          } else if (_panelController.isPanelClosed) {
            setState(() {
              _isVisible = true;
              FocusScope.of(context).unfocus();
            });
          }
        },
        body: _body(_panelController),

        // 編集中モードか追加するモードかで表示するスライドアップパネルを変える
        panel: _isEditing
            // 編集中の場合
            ? TodoEditPage(
                key: todoEditKey,
                panelController: _panelController,
                todoIdList: todoIdList,
                className: widget.className,
                classColor: widget.color,

                // TodoEditPageでTodoが更新された場合の処理
                // 編集前のoldTodoと編集後のnewTodoを引数に取る
                // oldTodoは削除し、newTodoは追加の処理を行う
                todoWasEdited: (oldTodo, newTodo) async {
                  // RiverpodでallTodoListの状態を更新
                  final notifier =
                      ref.read(allTodoListNotifierProvider.notifier);
                  notifier.updateTodo(oldTodo, newTodo);

                  _todoList.remove(oldTodo);
                  saveTodo();
                  // カレンダーのイベントからも削除
                  // Map todoEventsのkeyはDateTime.Utc()でない実装できないため
                  // 変換を行っている(toUTC()では実装不可)
                  DateTime utcDate = oldTodo.deadline.toUtc();
                  int utcYear = utcDate.year;
                  int utcMonth = utcDate.month;
                  int utcDay = utcDate.day;
                  utcDate = DateTime.utc(utcYear, utcMonth, utcDay);
                  todoEvents[utcDate]?.remove(oldTodo.content);
                  // Todoリストに追加してローカルに保存
                  _todoList.add(newTodo);
                  await saveTodo();

                  setState(() {
                    // カレンダーのイベントに追加
                    // Map todoEventsのkeyはDateTime.Utc()でない実装できないため変換を行っている(toUTC()では実装不可)
                    DateTime utcDate = newTodo.deadline.toUtc();
                    int utcYear = utcDate.year;
                    int utcMonth = utcDate.month;
                    int utcDay = utcDate.day;
                    utcDate = DateTime.utc(utcYear, utcMonth, utcDay);
                    if (todoEvents[utcDate] == null) {
                      todoEvents[utcDate] = [newTodo.content];
                    } else {
                      todoEvents[utcDate]?.add(newTodo.content);
                    }
                  });

                  // _todoListを更新してカレンダーのイベントを更新
                  loadTodo().then((value) {
                    sortTodoByDeadline();
                    loadTodoEvents();
                  });
                },
              )

            // Todoを追加するモードの場合
            : TodoAddPage(
                panelController: _panelController,
                className: widget.className,
                todoIdList: todoIdList,
                classColor: widget.color,

                // TodoAddPageからTodoが追加された場合の処理
                todoWasAdded: (todo) {
                  // RiverpodでallTodoListの状態を更新
                  final notifier =
                      ref.read(allTodoListNotifierProvider.notifier);
                  notifier.addTodo(todo);

                  // Todoリストに追加してローカルに保存
                  _todoList.add(todo);
                  saveTodo();

                  // カレンダーのイベントに追加
                  // Map todoEventsのkeyはDateTime.Utc()でない実装できないため変換を行っている(toUTC()では実装不可)
                  DateTime utcDate = todo.deadline.toUtc();
                  int utcYear = utcDate.year;
                  int utcMonth = utcDate.month;
                  int utcDay = utcDate.day;
                  utcDate = DateTime.utc(utcYear, utcMonth, utcDay);
                  if (todoEvents[utcDate] == null) {
                    todoEvents[utcDate] = [todo.content];
                  } else {
                    todoEvents[utcDate]?.add(todo.content);
                  }

                  // Todoが追加された場合は_todoListを更新してカレンダーのイベントを更新
                  loadTodo().then((value) {
                    sortTodoByDeadline();
                    loadTodoEvents();
                  });
                },
              ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: Container(
          margin: const EdgeInsets.only(right: 25),
          child: FloatingActionButton(
            backgroundColor: widget.color,
            // floatingActionButtonが押された場合はスライドアップパネルを表示する
            onPressed: () {
              HapticFeedback.mediumImpact();
              _panelController.open();
              setState(() {
                _isEditing = false;
                _isVisible = false;
              });
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  // スライドアップパネルのbody部分
  Widget _body(PanelController panelController) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        panelController.close();
      },
      child: Column(
        children: [
          Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: Center(
                child: Text(
                  widget.className,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
              )),

          // カレンダー実装部分
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: MediaQuery.of(context).size.width * 0.95,
            child: TableCalendar(
              // カレンダーのスタイルを変えるための設定(日付の色の変更)
              calendarBuilders: CalendarBuilders(defaultBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: _textColor(day),
                    ),
                  ),
                );
              }, markerBuilder:
                  (BuildContext context, DateTime day, List todoIds) {
                List<Widget> markers = [];
                // Todoが完了(チェックボックスにチェックが入っている場合)の場合とそれ以外の場合でマーカーを変える
                for (var todoId in todoIds) {
                  // 該当のTodoが_todoList内に存在する場合にのみ処理を実行
                  int index = _todoList.indexWhere((todo) => todo.id == todoId);
                  if (index != -1) {
                    if ((!_todoList[index].isDone &&
                        _todoList[index].deadline
                            .isBefore(DateTime.now()))) {
                      markers.add(const Text(
                        '●',
                        style: TextStyle(
                          fontSize: 7,
                          color: Colors.red,
                        ),
                      ));
                    } 
                    else if (_todoList[index].isDone) {
                      markers.add(Text(
                        '●',
                        style: TextStyle(
                          fontSize: 7,
                          color: Colors.grey[350],
                        ),
                      ));
                    } else {
                      markers.add(Text(
                        '●',
                        style: TextStyle(
                          fontSize: 7,
                          color: widget.color,
                        ),
                      ));
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 27),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: markers,
                  ),
                );
              }),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              // カレンダーの上の部分のスタイルを変えるための設定
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true, //この行を追加
              ),

              // カレンダーのイベントの実装
              eventLoader: (date) {
                return todoEvents[date] ?? [];
              },

              shouldFillViewport: true, // カレンダーの高さを調節可能に設定
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2050, 1, 1),
              focusedDay: DateTime.now(),
              locale: 'ja_JP',
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) => setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              }),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // 追加された課題を表示する部分
          Expanded(
            child: SlidableAutoCloseBehavior(
              closeWhenOpened: true, // 他がスライドされたら自動で閉じる
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  // タスクが完了した場合の処理
                  return TodoTaskTile(
                    todo: _todoList[index],

                    // Todoが削除された時の処理
                    todoWasDeleted: (todo) {
                      // RiverpodでallTodoListの状態を更新
                      final notifier =
                          ref.read(allTodoListNotifierProvider.notifier);
                      notifier.removeTodo(todo);

                      _todoList.remove(todo);
                      saveTodo();
                      // カレンダーのイベントからも削除
                      // Map todoEventsのkeyはDateTime.Utc()でない実装できないため
                      // 変換を行っている(toUTC()では実装不可)
                      DateTime utcDate = todo.deadline.toUtc();
                      int utcYear = utcDate.year;
                      int utcMonth = utcDate.month;
                      int utcDay = utcDate.day;
                      utcDate = DateTime.utc(utcYear, utcMonth, utcDay);
                      todoEvents[utcDate]?.remove(todo.content);
                    },

                    // Todoのタスクのチェックボックスが変更された場合の処理
                    todoWasTapped: (todo) {
                      // RiverpodでallTodoListの状態を更新
                      final notifier =
                          ref.read(allTodoListNotifierProvider.notifier);
                      notifier.updateIsDone(todo);

                      // Todoリストの該当するTodoのisDoneを更新
                      _todoList[_todoList.indexOf(todo)].isDone = !todo.isDone;
                      saveTodo();
                    },

                    // Todo長押しされた場合の処理　(Todoを編集)
                    todoWasLongPressed: (todo) async {
                      setState(() {
                        _isEditing = true;
                        _isVisible = false;
                      });

                      // keyを取得するために少し待機
                      await Future.delayed(const Duration(milliseconds: 100));

                      (todoEditKey?.currentState as TodoEditPageState)
                          .setTodo(todo);

                      // Todoを編集
                      HapticFeedback.mediumImpact();
                      _panelController.open();
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
