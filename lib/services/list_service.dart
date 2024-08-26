import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/todo_item.dart';

part 'list_service.g.dart';

const serverHost = "http://192.168.31.182:3300";

@riverpod
Future<List<TodoItem>> todoList(TodoListRef ref) async {
  final response = await http.get(Uri.parse('$serverHost/todo/0'));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['message'] != 'OK') {
      return <TodoItem>[];
    }

    final data = body['data'] as List<dynamic>;
    final List<TodoItem> todoItemList = [];
    for (var e in data) {
      todoItemList.add(TodoItem.fromJson(e));
    }

    return todoItemList;
  } else {
    return <TodoItem>[];
  }
}
