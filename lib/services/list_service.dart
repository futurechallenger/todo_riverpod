import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/todo_item.dart';

part 'list_service.g.dart';

@riverpod
Future<List<TodoItem>> todoList(TodoListRef ref) async {
  final response =
      await http.get(Uri.parse('http://192.168.31.182:17788/list/all'));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['message'] != 'ok') {
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

@riverpod
Future<TodoItem?> addTodo(AddTodoRef ref, TodoItem todo) async {
  final response = await http.post(Uri.parse('http://192.168.31.182:17788/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(todo));
  if (response.statusCode != 200) {
    throw Exception("Error adding todo");
  }

  final body = jsonDecode(response.body) as Map<String, dynamic>;
  if (body['message'] != 'ok') {
    throw Exception("Response from service is invalid");
  }

  return TodoItem.fromJson(body['data']);
}
