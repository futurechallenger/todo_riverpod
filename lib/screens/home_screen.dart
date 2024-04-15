import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/models/todo_item.dart';
import 'package:todo_riverpod/screens/detail_screen.dart';
import 'package:todo_riverpod/services/todo_list_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final todoList = ref.watch(todoListServiceProvider);
      return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
          actions: [
            IconButton(
                onPressed: () {
                  context.push("/settings");
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: switch (todoList) {
          AsyncData(:final value) => ListView.builder(
              itemBuilder: (context, index) {
                final item = value[index];
                return ListTile(
                  title: Text(item.content),
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailScreen(),
                            settings: RouteSettings(arguments: value[index])));

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text('result: $result')));
                  },
                );
              },
              itemCount: value.length,
            ),
          AsyncError(:final error) => Text("Error $error"),
          _ => const CircularProgressIndicator(),
        },
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Title"),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(todoListServiceProvider.notifier)
                                  .addTodo(TodoItem(
                                    content: _controller.text,
                                  ));
                              _controller.text = "";
                              context.pop();
                            },
                            child: const Text("OK")),
                        ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("Cancel"))
                      ],
                    ));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
