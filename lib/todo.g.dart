// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      isDone: json['isDone'] as bool,
      content: json['content'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      id: json['id'] as String,
      className: json['className'] as String,
      classColor: const ColorConverter().fromJson(json['classColor'] as int),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'isDone': instance.isDone,
      'content': instance.content,
      'deadline': instance.deadline.toIso8601String(),
      'id': instance.id,
      'className': instance.className,
      'classColor': const ColorConverter().toJson(instance.classColor),
    };
