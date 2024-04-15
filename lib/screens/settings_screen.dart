import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final settingsOptions = ["Theme", "Animation", "Isolate"];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  title: Text(settingsOptions[index]),
                  onTap: () {
                    switch (index) {
                      case 2:
                        context.push("/settings/isolate");
                      default:
                        debugPrint("nothing matched");
                    }
                  },
                ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: settingsOptions.length),
      ),
    );
  }
}
