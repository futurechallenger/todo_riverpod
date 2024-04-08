import 'package:flutter/material.dart';
import 'package:todo_riverpod/models/todo_item.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as TodoItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                todo.content,
                style: const TextStyle(color: Colors.deepOrange, fontSize: 30),
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, '${todo.content} is read');
                  },
                  child: const Text("Back")),
            ),
          ],
        ),
      ),
    );
  }
}
