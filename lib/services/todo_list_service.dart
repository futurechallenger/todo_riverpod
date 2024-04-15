import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:todo_riverpod/models/todo_item.dart';

part 'todo_list_service.g.dart';

@Riverpod(keepAlive: true)
class TodoListService extends _$TodoListService {
  @override
  Future<List<TodoItem>> build() async {
    try {
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
    } catch (e) {
      debugPrint("Error $e");
      return <TodoItem>[];
    }
  }

  Future<void> addTodo(TodoItem todo) async {
    final response = await http.post(
        Uri.parse('http://192.168.31.182:17788/add'),
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

    /*
      1. If addTodo api returns a todo list. After parsing the todo list, assign it to the state.
      2. Still api returns a todo list. First invalidateSelf(), then await future to make sure new state is available
      3. Manually update state. Get the previous state, then `final state = AsyncData([previousState, newTodo])`
    */

    /*
      Since the backend api returns only a just added todo
      If you want to refresh the list page after a todo is added,
      Use the second option:

      ref.invalidateSelf(); 
      await future;

      The todo list will be get automatically.
    */

    ref.invalidateSelf();
    await future;
  }
}
