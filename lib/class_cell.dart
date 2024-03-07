import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_timetable/class_cell_contents.dart';
import 'package:todo_timetable/class_option_dialog.dart';

// 曜日
enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

// enum Day を拡張して、曜日の文字列を取得するメソッド
extension on Day {
  String get string => this.toString().split(".").last;
}

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
    getClassCellContents(); // sharedPreferenceからclassCellContentsを取得
  }

  // classCellContentsをsharedPreferenceでローカルに保存するメソッド
  Future saveClassCellContents() async {
    // sharedPreferenceに保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${widget.day.string}_${widget.period}_classCellContents',
        json.encode(contents.toJson()));

    print('saved : ${contents.toJson()}');
  }

  // sharedPreferenceからclassCellContentsを取得するメソッド
  Future getClassCellContents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? classCellContents = prefs
        .getString('${widget.day.string}_${widget.period}_classCellContents');
    if (classCellContents != null) {
      setState(() {
        contents = ClassCellContents.fromJson(json.decode(classCellContents));
      });
    }
    print('loaded : classCellContents');
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
                  color: contents.color,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    // 授業名を表示
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: Text(
                        contents.className,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    // 教室名を表示
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 60, maxWidth: 60),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 7),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(contents.roomName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 9)),
                        ),
                      ),
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
          onTap: () async{
            // タップされると授業を追加するモーダルを表示
            await showClassNameDialog(context);
            saveClassCellContents(); // sharedPreferenceに保存
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
    String className = '';
    String roomName = '';
    Color color;

    // モーダルの戻り値は '授業名,教室名,カラーコード' の文字列
    final returnContents = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const ClassOptionDialog(),
    );

    List<String> returnList = returnContents!.split(',');
    className = returnList[0];
    roomName = returnList[1];
    color = Color(int.parse(returnList[2]));

    if (!contents.hasClass) {
      setState(() {
        contents.className = className;
        contents.roomName = roomName;
        contents.color = color;
        contents.hasClass = true;
      });
    }
  }
}
