// 時間割のマス目を表示するクラス
// マス目をタップすると授業を追加するモーダルが表示される
// すでに授業が追加されている状態で、マス目を長押しすると授業を編集するモーダルが表示される

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_timetable/class_cell_contents.dart';
import 'package:todo_timetable/class_edit_dialog.dart';
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
    loadClassCellContents(); // sharedPreferenceからclassCellContentsを取得
  }

  // classCellContentsをsharedPreferenceでローカルに保存するメソッド
  Future saveClassCellContents() async {
    // sharedPreferenceに保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${widget.day.string}_${widget.period}_classCellContents',
        json.encode(contents.toJson()));
  }

  // sharedPreferenceからclassCellContentsを取得するメソッド
  Future loadClassCellContents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? classCellContents = prefs
        .getString('${widget.day.string}_${widget.period}_classCellContents');
    if (classCellContents != null) {
      setState(() {
        contents = ClassCellContents.fromJson(json.decode(classCellContents));
      });
    }
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
              HapticFeedback.lightImpact();
              // タップされるとその授業の詳細ページに遷移
              context.go(
                  '/class_${widget.period}_${widget.day.index + 1}/${contents.className}/${contents.color.value}');
            },
            onLongPress: () async {
              // 長押しされると授業を編集するモーダルを表示
              HapticFeedback.heavyImpact(); // 長押しのフィードバック
              if (!context.mounted) return;
              await showClassEditDialog(context);
              
              saveClassCellContents(); // sharedPreferenceに保存
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
          onTap: () async {
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

  // 授業を追加するモーダルを表示するメソッド
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

  // 授業を編集するモーダルを表示するメソッド
  Future<void> showClassEditDialog(BuildContext context) async {
    String className = contents.className;
    String roomName = contents.roomName;
    Color color = contents.color;
    // 授業を編集するモーダルにアクセスするためのGlobalObjectKey
    GlobalObjectKey classEditDialogKey =
        GlobalObjectKey<ClassEditDialogState>(context);

    // モーダルの戻り値は '授業名,教室名,カラーコード' の文字列
    final returnContents = await showDialog<String>(
      context: context,
      builder: (BuildContext context) =>  ClassEditDialog(key: classEditDialogKey, className: className,),
    );


    // 削除された場合は初期化して削除　（hasClass = false で削除可能）
    if (returnContents == 'delete') {
      setState(() {
        contents.className = '';
        contents.roomName = '';
        contents.color = const Color(0xFFB7E6A6);
        contents.hasClass = false;
      });
      return;
    }

    // 削除されず編集された場合は編集内容を反映
    List<String> returnList = returnContents!.split(',');
    className = returnList[0];
    roomName = returnList[1];
    color = Color(int.parse(returnList[2]));

    setState(() {
      contents.className = className;
      contents.roomName = roomName;
      contents.color = color;
      contents.hasClass = true;
    });
  }
}
