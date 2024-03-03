

import 'package:json_annotation/json_annotation.dart';
part 'todo.g.dart';

@JsonSerializable()
class Todo {
  bool isDone;
  String content;
  final DateTime deadline;
  final String id;

  Todo({
    required this.isDone,
    required this.content,
    required this.deadline,
    required this.id,
  });

  // Json <=> Todo の変換用メソッド
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
