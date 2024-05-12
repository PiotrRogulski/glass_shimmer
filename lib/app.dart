import 'package:flutter/material.dart';
import 'package:glass_shimmer/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF0000),
          brightness: Brightness.dark,
        ).copyWith(
          shadow: Colors.transparent,
        ),
      ).copyWith(
        splashFactory: InkSparkle.splashFactory,
      ),
      home: const Home(),
    );
  }
}
