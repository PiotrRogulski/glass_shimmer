import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

enum BorderState {
  base(width: 4, elevation: 0),
  hover(width: 8, elevation: 0),
  pressed(width: 10, elevation: -100),
  ;

  const BorderState({required this.width, required this.elevation});

  final double width;
  final double elevation;
}

class BorderStateBuilder extends HookWidget {
  const BorderStateBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    double borderWidth,
    double elevation,
    WidgetStatesController statesController,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final state = useState(BorderState.base);
    final statesController = useMaterialStatesController();

    useEffect(
      () {
        void listener() {
          if (statesController.value.contains(WidgetState.pressed)) {
            state.value = BorderState.pressed;
          } else if (statesController.value.contains(WidgetState.hovered)) {
            state.value = BorderState.hover;
          } else {
            state.value = BorderState.base;
          }
        }

        statesController.addListener(listener);
        return () => statesController.removeListener(listener);
      },
      [statesController],
    );

    return TweenAnimationBuilder(
      tween: Tween(begin: BorderState.base.width, end: state.value.width),
      duration: Durations.medium1,
      curve: Easing.standard,
      builder: (context, borderWidth, child) {
        return TweenAnimationBuilder(
          tween: Tween(
            begin: BorderState.base.elevation,
            end: state.value.elevation,
          ),
          duration: Durations.medium1,
          curve: Easing.standard,
          builder: (context, elevation, child) {
            return builder(context, borderWidth, elevation, statesController);
          },
        );
      },
    );
  }
}
