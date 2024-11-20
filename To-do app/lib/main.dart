import "package:flutter/material.dart";
import 'package:to_do_app_demo/todo_app_ui.dart';

void main() {
  runApp(const todoapp());
}

class todoapp extends StatelessWidget {
  const todoapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: toDoapp(),
    );
  }
}
