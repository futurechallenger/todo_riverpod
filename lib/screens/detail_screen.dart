import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/models/todo_item.dart';
import 'package:todo_riverpod/services/todo_list_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.todo});

  final TodoItem todo;
  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void>? _pendingTodo;
  bool _showTextField = false;
  String _hintText = '';

  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller.text = widget.todo.content;

    setState(() {
      _hintText = _controller.text;
      _pendingTodo = null;
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (_controller.text.isNotEmpty) {
          setState(() {
            _hintText = _controller.text;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: FutureBuilder(
            future: _pendingTodo,
            builder: (context, snapshot) {
              bool hasError = snapshot.hasError &&
                  snapshot.connectionState != ConnectionState.waiting;

              if (hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text("Something wrong"),
                      backgroundColor: Colors.redAccent,
                    ));
                });
              }

              return Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: getUpdatingWidgets(snapshot, ref),
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(
                                //     context, '${todo.content} is read');
                                context.pop(widget.todo.content);
                              },
                              child: const Text("Back")),
                        ),
                      ],
                    ),
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(child: CircularProgressIndicator())
                ],
              );
            }),
      );
    });
  }

  Widget getUpdatingWidgets(AsyncSnapshot<void> snapshot, WidgetRef ref) {
    if (!_showTextField ||
        (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError)) {
      return TextButton(
        onPressed: () {
          debugPrint("todo is clicked");
          setState(() {
            _showTextField = true;
          });
        },
        child: Text(
          _hintText.isNotEmpty ? _hintText : _controller.text,
          style: const TextStyle(color: Colors.deepOrange, fontSize: 30),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              autofocus: true,
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                  hintText:
                      _hintText.isNotEmpty ? _hintText : _controller.text),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                final future = ref
                    .read(todoListServiceProvider.notifier)
                    .updateTodo(TodoItem(
                      id: widget.todo.id,
                      content: _controller.text,
                    ));
                FocusScope.of(context).unfocus();

                setState(() {
                  _pendingTodo = future;
                });
              },
              child: const Text("OK")),
        ],
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }
}
