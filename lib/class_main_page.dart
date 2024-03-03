// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_timetable/adding_todo_page.dart';
import 'package:todo_timetable/todo.dart';
import 'package:todo_timetable/todo_task_tile.dart';

class ClassMainPage extends StatefulWidget {
  final String className; // 授業名
  final List<String> todoIdList = []; // タスクIDリスト

  ClassMainPage({super.key, required this.className});
  final List<Todo> _todoList = []; // Todoリスト（ウィジェット）

  @override
  State<ClassMainPage> createState() => _ClassMainPageState();
}

class _ClassMainPageState extends State<ClassMainPage> {
  // ignore: unused_field
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final PanelController _panelController = PanelController();
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo'),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 20, bottom: 10),
              child: IconButton(
                  onPressed: () {
                    print("todo画面のメニューボタンが押されました");
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                  ))),
        ],
      ),
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        backdropEnabled: true,
        controller: _panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.25,

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
        panel: AddingTodoPage(
          panelController: _panelController, 
          todoList: widget._todoList,
          className: widget.className, 
          todoIdList: widget.todoIdList,
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: Container(
          margin: const EdgeInsets.only(right: 25),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFB7E6A6),
            // floatingActionButtonが押された場合はスライドアップパネルを表示する
            onPressed: () {
              _panelController.open();
              setState(() {
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
              decoration: const BoxDecoration(
                color: Color(0xFFB7E6A6),
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
              // カレンダーの上の部分のスタイルを変えるためのやつ
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true, //この行を追加
              ),
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
            child: ListView.builder(
              itemCount: widget._todoList.length,
              itemBuilder: (BuildContext context, int index) {
                return TodoTaskTile(todo: widget._todoList[index]);
              },
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
