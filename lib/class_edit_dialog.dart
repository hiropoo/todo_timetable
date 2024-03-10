import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_timetable/constant/color.dart';

class ClassEditDialog extends StatefulWidget {
  const ClassEditDialog({super.key});

  @override
  State<ClassEditDialog> createState() => _ClassEditDialogState();
}

class _ClassEditDialogState extends State<ClassEditDialog> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  Color selectedColor = MyColor.blue; // 選択された色

  bool isSelectingColor = false; // 色を選択中かどうか
  bool isAllFilled = false;

  // 全ての入力欄が埋まっているかどうか判定するメソッド
  bool allFilled() {
    return _classNameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFBFBFB),
      surfaceTintColor: Colors.transparent, // backgroundColorを適用するために必要
      title: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          '授業を編集',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666)),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 授業名を入力する部分
          SizedBox(
            height: 50,
            child: Focus(
              onFocusChange: (value) {
                if (value) {
                  setState(() {
                    isSelectingColor = false;
                  });
                }
              },
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    isAllFilled = allFilled();
                  });
                },
                cursorColor: Colors.grey[600],
                controller: _classNameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xff666666),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 99, 110, 184),
                      width: 1.5,
                    ),
                  ),
                  labelText: "授業名を入力してください",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // 教室名を入力する部分
          SizedBox(
            height: 50,
            child: Focus(
              onFocusChange: (value) {
                if (value) {
                  setState(() {
                    isSelectingColor = false;
                  });
                }
              },
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    isAllFilled = allFilled();
                  });
                },
                cursorColor: Colors.grey[600],
                controller: _roomNameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xff666666),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 99, 110, 184),
                      width: 1.5,
                    ),
                  ),
                  labelText: "教室名を入力してください",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          // 授業の色を選択する部分
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                isSelectingColor = true;
              });
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    color: (isSelectingColor
                        ? const Color.fromARGB(255, 99, 110, 184)
                        : const Color(0xFF666666)),
                    width: isSelectingColor ? 1.5 : 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '色を選択 : ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  // 青色の選択
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isSelectingColor = true;

                        selectedColor = MyColor.blue;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selectedColor == MyColor.blue ? 25 : 20,
                        height: selectedColor == MyColor.blue ? 25 : 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            selectedColor == MyColor.blue ? 25 : 20,
                          ),
                          color: MyColor.blue,
                        ),
                      ),
                    ),
                  ),
                  // 緑色の選択
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isSelectingColor = true;
                        selectedColor = MyColor.green;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selectedColor == MyColor.green ? 25 : 20,
                        height: selectedColor == MyColor.green ? 25 : 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            selectedColor == MyColor.blue ? 25 : 20,
                          ),
                          color: MyColor.green,
                        ),
                      ),
                    ),
                  ),
                  // 黄色の選択
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isSelectingColor = true;

                        selectedColor = MyColor.yellow;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selectedColor == MyColor.yellow ? 25 : 20,
                        height: selectedColor == MyColor.yellow ? 25 : 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            selectedColor == MyColor.blue ? 25 : 20,
                          ),
                          color: MyColor.yellow,
                        ),
                      ),
                    ),
                  ),
                  // 赤色の選択
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isSelectingColor = true;

                        selectedColor = MyColor.red;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selectedColor == MyColor.red ? 25 : 20,
                        height: selectedColor == MyColor.red ? 25 : 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            selectedColor == MyColor.red ? 25 : 20,
                          ),
                          color: MyColor.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
             showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("削除しますか？"),
                    content: const Text("この処理は取り消せません"),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => Navigator.of(context).pop('cancel'),
                        child:  Text('Cancel', style: TextStyle(color: Colors.blue[600]),),
                      ),
                      CupertinoDialogAction(
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();  // 現在のダイアログを閉じる
                          Navigator.of(context).pop('delete');  // 前のダイアログを閉じる
                          },
                      ),
                    ],
                  );
                });
          },
          child: const Text('削除', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
          child:
              const Text('キャンセル', style: TextStyle(color: Color(0xFF666666))),
        ),
        TextButton(
          onPressed: () {
            if (allFilled()) {
              Navigator.of(context).pop(
                  '${_classNameController.text},${_roomNameController.text},${selectedColor.value}');
            } else {
              null;
            }
          },
          child: Text('更新',
              style: TextStyle(
                  color: isAllFilled
                      ? const Color.fromARGB(255, 99, 110, 184)
                      : const Color(0xFF666666))),
        ),
      ],
    );
  }
}
