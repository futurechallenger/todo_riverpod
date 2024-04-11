import 'dart:isolate';

import 'package:flutter/material.dart';

int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

class IsolateScreen extends StatelessWidget {
  const IsolateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Isolate"),
        ),
        body: Center(
            child: ElevatedButton(
                onPressed: () async {
                  final result = await Isolate.run(() => slowFib(40));
                  debugPrint('Fib(40) result $result');
                },
                child: const Text("Isolate"))));
  }
}
