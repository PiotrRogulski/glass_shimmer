import 'package:flutter/material.dart';
import 'package:glass_shimmer/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF0000),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: colorScheme.copyWith(
          shadow: Colors.transparent,
        ),
      ).copyWith(
        splashFactory: InkSparkle.splashFactory,
        highlightColor: colorScheme.primary.withOpacity(0.07),
        hoverColor: colorScheme.primary.withOpacity(0.03),
        splashColor: colorScheme.primary.withOpacity(0.2),
      ),
      home: const Home(),
    );
  }
}
