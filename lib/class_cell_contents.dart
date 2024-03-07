import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_timetable/json_converter.dart';

part 'class_cell_contents.g.dart';

@JsonSerializable()
class ClassCellContents {
  String className = ''; // 授業名
  String roomName = ''; // 教室名（仮）本来はclassNameと同様にモーダルから取得

  @ColorConverter()
  Color color = const Color(0xFFB7E6A6); // 授業の色（仮）本来はclassNameと同様にモーダルから取得
  bool hasClass = false; // 授業がすでに追加されているかどうか

  ClassCellContents({
    this.className = '',
    this.roomName = '',
    this.color = const Color(0xFFB7E6A6),
    this.hasClass = false,
  });

  // Json <=> Todo の変換用メソッド
  factory ClassCellContents.fromJson(Map<String, dynamic> json) =>
      _$ClassCellContentsFromJson(json);

  Map<String, dynamic> toJson() => _$ClassCellContentsToJson(this);
}
