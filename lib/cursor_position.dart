import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

extension CursorPositionX on BuildContext {
  Offset? get cursorPosition => CursorPosition.of(this);
}

class CursorPosition extends HookWidget {
  const CursorPosition({
    super.key,
    required this.child,
  });

  final Widget child;

  static Offset? of(BuildContext context) {
    final cursorPosition =
        context.dependOnInheritedWidgetOfExactType<_CursorPosition>();
    assert(cursorPosition != null, 'No CursorPosition found in context');
    return cursorPosition!.cursorPosition;
  }

  @override
  Widget build(BuildContext context) {
    final cursorPosition = useState<Offset?>(null);

    void updatePosition(PointerEvent event) {
      if (context.size?.contains(event.position) ?? false) {
        cursorPosition.value = event.position;
      } else {
        cursorPosition.value = null;
      }
    }

    return MouseRegion(
      onExit: (_) => cursorPosition.value = null,
      child: Listener(
        onPointerMove: updatePosition,
        onPointerHover: updatePosition,
        child: _CursorPosition(
          cursorPosition: cursorPosition.value,
          child: child,
        ),
      ),
    );
  }
}

class _CursorPosition extends InheritedWidget {
  const _CursorPosition({
    required this.cursorPosition,
    required super.child,
  });

  final Offset? cursorPosition;

  @override
  bool updateShouldNotify(_CursorPosition oldWidget) =>
      cursorPosition != oldWidget.cursorPosition;
}
