// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoItemImpl _$$TodoItemImplFromJson(Map<String, dynamic> json) =>
    _$TodoItemImpl(
      id: json['id'] as int,
      content: json['content'] as String,
      note: json['note'] as String,
      deleted: json['deleted'] as int,
      status: json['status'] as int,
    );

Map<String, dynamic> _$$TodoItemImplToJson(_$TodoItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'note': instance.note,
      'deleted': instance.deleted,
      'status': instance.status,
    };
