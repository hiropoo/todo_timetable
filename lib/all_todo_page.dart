import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_timetable/all_todo_list.dart';
import 'package:todo_timetable/todo.dart';
import 'package:todo_timetable/todo_task_tile_for_all_todo_page.dart';

class AllTodoPage extends ConsumerWidget {
  AllTodoPage({
    super.key,
  });

  final Map<DateTime?, List<String>> todoEvents = {}; // カレンダーのイベント(TodoのIDを保存)

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
  Widget build(BuildContext context, WidgetRef ref) {
    final allTodoList = ref.watch(allTodoListNotifierProvider);
    DateTime? selectedDay;
    // ignore: unused_local_variable
    DateTime focusedDay = DateTime.now();

    final notifier = ref.read(allTodoListNotifierProvider.notifier);
    notifier.sortTodoByDeadline();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('すべてのTodo',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF666666))),
      ),
      body: Column(
        children: [
          // カレンダー実装部分
          Container(
            decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 99, 110, 184),
                width: 2,
              ),
            ),
          ),
            child: SizedBox(
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
                    // 該当のTodoがallTodoList内に存在する場合にのみ処理を実行
                    int index = allTodoList.asData!.value
                        .indexWhere((todo) => todo.id == todoId);
                    if (index != -1) {
                      if((!allTodoList.asData!.value[index].isDone && allTodoList.asData!.value[index].deadline.isBefore(DateTime.now()))){
                        markers.add(const Text(
                          '●',
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.red,
                          ),
                        ));
                      }
                      else if (allTodoList.asData!.value[index].isDone) {
                        markers.add(Text(
                          '●',
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.grey[350],
                          ),
                        ));
                      } else {
                        markers.add(const Text(
                          '●',
                          style: TextStyle(
                            fontSize: 7,
                            color: Color.fromARGB(255, 99, 110, 184),
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
                  List<String> todoIds = allTodoList.asData?.value
                          .where((todo) => isSameDay(todo.deadline, date))
                          .map((todo) => todo.id)
                          .toList() ??
                      [];
                  return todoIds;
                },
            
                shouldFillViewport: true, // カレンダーの高さを調節可能に設定
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2050, 1, 1),
                focusedDay: DateTime.now(),
                locale: 'ja_JP',
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              ),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // 追加された課題を表示する部分
          Expanded(
            child: ListView.builder(
              itemCount: allTodoList.when(data: (data) {
                return data.length;
              }, error: (error, stackTrace) {
                return 0;
              }, loading: () {
                return 0;
              }),
              itemBuilder: (BuildContext context, int index) {
                // タスクが完了した場合の処理
                return TodoTaskTileForAllTodoPage(
                  todo: allTodoList.when(data: (data) {
                    return data[index];
                  }, error: (error, stackTrace) {
                    return Todo(
                      isDone: false,
                      content: 'error',
                      deadline: DateTime.now(),
                      id: '',
                    );
                  }, loading: () {
                    return Todo(
                      isDone: false,
                      content: 'loading...',
                      deadline: DateTime.now(),
                      id: '',
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
