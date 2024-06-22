import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

extension CursorPositionX on BuildContext {
  ({Offset position, bool isActive}) get cursorPosition =>
      CursorPosition.of(this);
}

class CursorPosition extends HookWidget {
  const CursorPosition({
    super.key,
    required this.child,
  });

  final Widget child;

  static ({Offset position, bool isActive}) of(BuildContext context) {
    final cursorPosition =
        context.dependOnInheritedWidgetOfExactType<_CursorPosition>();
    assert(cursorPosition != null, 'No CursorPosition found in context');
    cursorPosition!;
    return (
      position: cursorPosition.cursorPosition,
      isActive: cursorPosition.cursorActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cursorPosition = useState<Offset>(Offset.zero);
    final cursorActive = useState(false);

    void updatePosition(PointerEvent event) {
      cursorActive.value = context.size?.contains(event.position) ?? false;
      if (cursorActive.value) {
        cursorPosition.value = event.position;
      }
    }

    return MouseRegion(
      onEnter: updatePosition,
      onExit: (_) => cursorActive.value = false,
      child: Listener(
        onPointerMove: updatePosition,
        onPointerHover: updatePosition,
        onPointerDown: (event) {
          if (event.kind != PointerDeviceKind.mouse) {
            cursorActive.value = true;
          }
        },
        onPointerUp: (event) {
          if (event.kind != PointerDeviceKind.mouse) {
            cursorActive.value = false;
          }
        },
        onPointerCancel: (event) {
          if (event.kind != PointerDeviceKind.mouse) {
            cursorActive.value = false;
          }
        },
        child: _CursorPosition(
          cursorPosition: cursorPosition.value,
          cursorActive: cursorActive.value,
          child: child,
        ),
      ),
    );
  }
}

class _CursorPosition extends InheritedWidget {
  const _CursorPosition({
    required this.cursorPosition,
    required this.cursorActive,
    required super.child,
  });

  final Offset cursorPosition;
  final bool cursorActive;

  @override
  bool updateShouldNotify(_CursorPosition oldWidget) =>
      cursorPosition != oldWidget.cursorPosition ||
      cursorActive != oldWidget.cursorActive;
}
