import 'package:flutter/material.dart';
import 'package:todo_timetable/class_cell.dart';

// 時間割を表示するウィジェット

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('週時間割',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                    fontSize: 20)),
          ),
        ),
        body: const MainTable());
  }
}

class MainTable extends StatelessWidget {
  const MainTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCECECE)),
      ),
      child: Column(children: [
        Row(children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCECECE)),
              ),
              height: 30,
            ),
          ),
          const DayWidget(day: '月'),
          const DayWidget(day: '火'),
          const DayWidget(day: '水'),
          const DayWidget(day: '木'),
          const DayWidget(day: '金'),
        ]),
        for (var i = 1; i <= 6; i++) TimeTableRow(period: i),
      ]),
    );
  }
}

// 曜日を表示するウィジェット
class DayWidget extends StatelessWidget {
  const DayWidget({super.key, required this.day});
  final String day; // 曜日

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCECECE)),
        ),
        padding: const EdgeInsets.all(4),
        child: Text(
          day,
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// 曜日
enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

// 時限ごとの時間割を表示するウィジェット
class TimeTableRow extends StatelessWidget {
  const TimeTableRow({super.key, required this.period});
  final int period; // 時限

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCECECE)),
              ),
              child: Center(
                child: Text(
                  period.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
        ClassCell(period: period, day: Day.monday),
        ClassCell(period: period, day: Day.tuesday),
        ClassCell(period: period, day: Day.wednesday),
        ClassCell(period: period, day: Day.thursday),
        ClassCell(period: period, day: Day.friday),
      ]),
    );
  }
}
