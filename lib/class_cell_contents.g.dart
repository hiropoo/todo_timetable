// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_cell_contents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassCellContents _$ClassCellContentsFromJson(Map<String, dynamic> json) =>
    ClassCellContents(
      className: json['className'] as String? ?? '',
      roomName: json['roomName'] as String? ?? '',
      color: json['color'] == null
          ? const Color(0xFFB7E6A6)
          : const ColorConverter().fromJson(json['color'] as int),
      hasClass: json['hasClass'] as bool? ?? false,
    );

Map<String, dynamic> _$ClassCellContentsToJson(ClassCellContents instance) =>
    <String, dynamic>{
      'className': instance.className,
      'roomName': instance.roomName,
      'color': const ColorConverter().toJson(instance.color),
      'hasClass': instance.hasClass,
    };
