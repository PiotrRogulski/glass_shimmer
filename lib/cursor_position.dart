import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class CursorPosition extends HookWidget {
  const CursorPosition({super.key, required this.child});

  final Widget child;

  static ({Offset position, bool isActive}) of(BuildContext context) {
    final data = context
        .dependOnInheritedWidgetOfExactType<CursorPositionData>()!;
    return (position: data.position, isActive: data.isActive);
  }

  @override
  Widget build(BuildContext context) {
    final position = useState(Offset.zero);
    final isActive = useState(false);

    useEffect(() {
      void update(PointerEvent event) {
        position.value = event.position;
        isActive.value = switch (event) {
          PointerRemovedEvent() => false,
          PointerAddedEvent() => true,
          _ => isActive.value,
        };
      }

      GestureBinding.instance.pointerRouter.addGlobalRoute(update);
      return () =>
          GestureBinding.instance.pointerRouter.removeGlobalRoute(update);
    }, []);

    return CursorPositionData(
      position: position.value,
      isActive: isActive.value,
      child: child,
    );
  }
}

class CursorPositionData extends InheritedWidget {
  const CursorPositionData({
    super.key,
    required this.position,
    required this.isActive,
    required super.child,
  });

  final Offset position;
  final bool isActive;

  @override
  bool updateShouldNotify(covariant CursorPositionData oldWidget) =>
      position != oldWidget.position || isActive != oldWidget.isActive;
}
