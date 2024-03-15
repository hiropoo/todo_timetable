import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:todo_timetable/json_converter.dart';

part 'todo.g.dart';

// flutter pub run build_runner build
@JsonSerializable()
class Todo {
  bool isDone;
  String content;
  final DateTime deadline;
  final String id;
  final String className;
  @ColorConverter()
  final Color classColor;

  Todo({
    required this.isDone,
    required this.content,
    required this.deadline,
    required this.id,
    required this.className,
    required this.classColor,
  });

  // Json <=> Todo の変換用メソッド
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
