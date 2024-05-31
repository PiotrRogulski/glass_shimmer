import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class BorderWidthBuilder extends HookWidget {
  const BorderWidthBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    double borderWidth,
    WidgetStatesController statesController,
  ) builder;

  static const widths = (
    base: 4.0,
    hover: 8.0,
    pressed: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    final borderWidth = useState(widths.base);
    final statesController = useMaterialStatesController();

    useEffect(
      () {
        void listener() {
          if (statesController.value.contains(WidgetState.pressed)) {
            borderWidth.value = widths.pressed;
          } else if (statesController.value.contains(WidgetState.hovered)) {
            borderWidth.value = widths.hover;
          } else {
            borderWidth.value = widths.base;
          }
        }

        statesController.addListener(listener);
        return () => statesController.removeListener(listener);
      },
      [statesController],
    );

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: widths.base, end: borderWidth.value),
      duration: Durations.medium1,
      curve: Easing.standard,
      builder: (context, borderWidth, child) {
        return builder(context, borderWidth, statesController);
      },
    );
  }
}
