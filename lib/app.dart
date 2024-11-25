import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_shimmer/home.dart';
import 'package:glass_shimmer/widgets/edge_blur.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF0000),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        theme: ThemeData.from(
          colorScheme: colorScheme.copyWith(shadow: Colors.transparent),
        ).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        home: const EdgeBlur(child: Home()),
      ),
    );
  }
}
