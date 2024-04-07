import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Detail Page")),
        ),
      ),
    );
  }
}
