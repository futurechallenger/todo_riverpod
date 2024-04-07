import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/screens/detail_screen.dart';
import 'package:todo_riverpod/services/list_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
        ),
        body: switch (todoList) {
          AsyncData(:final value) => ListView.builder(
              itemBuilder: (context, index) {
                final item = value[index];
                return ListTile(
                  title: Text(item.content),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailScreen()));
                  },
                );
              },
              itemCount: value.length,
            ),
          AsyncError(:final error) => Text("Error $error"),
          _ => const CircularProgressIndicator(),
        });
  }
}
