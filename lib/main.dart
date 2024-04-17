import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/models/todo_item.dart';
import 'package:todo_riverpod/screens/detail_screen.dart';
import 'package:todo_riverpod/screens/home_screen.dart';
import 'package:todo_riverpod/screens/isolate_screen.dart';
import 'package:todo_riverpod/screens/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => HomeScreen()),
        GoRoute(
            path: '/detail',
            builder: (context, state) {
              TodoItem todo = state.extra as TodoItem;
              return DetailScreen(todo: todo);
            }),
        GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
            routes: [
              GoRoute(
                  path: 'isolate', builder: (_, __) => const IsolateScreen())
            ]),
      ]),
      // home: const HomeScreen(),
    );
  }
}
