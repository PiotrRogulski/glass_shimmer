import 'package:flutter/material.dart';
import 'package:glass_shimmer/cursor_position.dart';

void main() {
  runApp(
    const CursorPosition(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cursorPosition = context.cursorPosition;

    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF0000),
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Hello World!'),
              Text('Cursor position: $cursorPosition'),
            ],
          ),
        ),
      ),
    );
  }
}
