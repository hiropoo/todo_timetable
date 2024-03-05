import 'package:flutter/material.dart';

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
                    fontWeight: FontWeight.w600, color: Color(0xFF666666))),
          ),
        ),
        body: Container(
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
        ));
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
        for (var i = 1; i <= 5; i++)
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => debugPrint("Taped"),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCECECE)),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
