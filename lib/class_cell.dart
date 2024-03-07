import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_timetable/class_cell_contents.dart';
import 'package:todo_timetable/class_option_dialog.dart';
import 'package:todo_timetable/time_table.dart';


class ClassCell extends StatefulWidget {
  final int period;
  final Day day;

  const ClassCell({
    super.key,
    required this.period,
    required this.day,
  });

  @override
  State<ClassCell> createState() => _ClassCellState();
}

@JsonSerializable()
class _ClassCellState extends State<ClassCell> {
  ClassCellContents contents = ClassCellContents();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contents.hasClass) {
      return Expanded(
        flex: 3,
        // 罫線を引くためのコンテナ
        child: Container(
          padding: const EdgeInsets.all(1.5),

          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCECECE)),
          ),
          // 授業のアイコンを表示するコンテナ
          child: GestureDetector(
            onTap: () {
              // タップされるとその授業の詳細ページに遷移
              context.go(
                  '/class_${widget.period}_${widget.day.index + 1}/${contents.className}/${contents.color.value}');
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 1.5),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFB7E6A6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      contents.className,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: const Text("教室名(仮)",
                          style: TextStyle(color: Colors.black, fontSize: 10)),
                    )
                  ],
                )),
          ),
        ),
      );
    } else {
      return Expanded(
        flex: 3,
        child: InkWell(
          onTap: () {
            // タップされると授業を追加するモーダルを表示
            showClassNameDialog(context);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCECECE)),
            ),
          ),
        ),
      );
    }
  }

  Future<void> showClassNameDialog(BuildContext context) async {
    final returnClassName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const ClassOptionDialog(),
    );

    if (!contents.hasClass) {
      setState(() {
        contents.className = returnClassName!;
        contents.hasClass = true;
      });
    }
  }
}
