import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_shimmer/app.dart';
import 'package:glass_shimmer/cursor_position.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const CursorPosition(child: App()));
}
