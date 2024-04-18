import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isolate_screen.g.dart';

int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

Future<void> spawnFib(SendPort sendPort) async {
  final commandPort = ReceivePort();
  sendPort.send(commandPort.sendPort);

  await for (final message in commandPort) {
    if (message is int) {
      // final target = int.parse(message);
      final target = message;

      debugPrint("received message $target");

      final result = slowFib(target);

      debugPrint("cal result $result");

      sendPort.send(result);
    } else if (message == null) {
      break;
    }
  }

  debugPrint("Spawn isolate existing...");
  Isolate.exit();
}

@riverpod
Future<int> calFib(CalFibRef ref, int target) async {
  // final result = await Isolate.run(() => slowFib(target));
  final result = await compute(slowFib, target);
  return result;
}

@riverpod
class CalFib2 extends _$CalFib2 {
  @override
  int build() {
    debugPrint("notifier build");
    return 0;
  }

  Future<int> calculate(int target) async {
    // final result = await Isolate.run(() => slowFib(target));
    final result = await compute(slowFib, target);
    return result;
  }

  // Future<int> calculateWithSpawn(int target) async {}
}

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  Future<int>? _pendingFuture;
  int _initVal = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Isolate"),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            return FutureBuilder(
                future: _pendingFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError &&
                      snapshot.connectionState != ConnectionState.waiting) {
                    return const Text("Something wrong happened");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final future = ref
                                      .read(calFib2Provider.notifier)
                                      .calculate(40);

                                  setState(() {
                                    _pendingFuture = future;
                                  });
                                },
                                child: const Text("Calculate")),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                final p = ReceivePort();
                                await Isolate.spawn(spawnFib, p.sendPort);

                                SendPort? sendPort;

                                await for (var response in p) {
                                  if (response is SendPort) {
                                    sendPort = response;
                                    sendPort.send(40);
                                  }

                                  if (response is int) {
                                    // TODO: show calulation result
                                    debugPrint('received message $response');
                                    break;
                                  }
                                }

                                if (sendPort != null) sendPort.send(null);
                              },
                              child: const Text("Cal with spawn"),
                            ),
                          ),
                          Expanded(
                              child: _initVal == 1
                                  ? const Text("OK")
                                  : ElevatedButton(
                                      onPressed: () {}, child: Text("click")))
                        ],
                      ),
                      if (snapshot.hasData)
                        Text("Cal result ${snapshot.data ?? ''}"),
                      const Spacer(),
                    ],
                  );
                });
          },
        ));
  }
}
