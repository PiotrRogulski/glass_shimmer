import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glass_shimmer/cursor_position.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class Shimmer extends HookWidget {
  const Shimmer({
    super.key,
    this.borderColor,
    this.borderRadius = BorderRadius.zero,
    this.showBaseBorder = true,
    this.statesController,
    required this.child,
  });

  final Color? borderColor;
  final BorderRadius borderRadius;
  final bool showBaseBorder;
  final WidgetStatesController? statesController;
  final Widget child;

  static const widths = (
    base: 4.0,
    hover: 8.0,
    pressed: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = this.borderColor ?? colorScheme.outline;

    final borderWidth = useState(widths.base);

    useEffect(
      () {
        final statesController = this.statesController;
        if (statesController == null) {
          return null;
        }

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

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        if (showBaseBorder)
          Positioned.fill(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: widths.base, end: borderWidth.value),
              duration: Durations.medium1,
              curve: Easing.standard,
              builder: (context, borderWidth, child) {
                return IgnorePointer(
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                        side: BorderSide(
                          color: borderColor.withOpacity(0.15),
                          width: borderWidth,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        Positioned.fill(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: widths.base, end: borderWidth.value),
            duration: Durations.medium1,
            curve: Easing.standard,
            builder: (context, borderWidth, child) {
              return ShimmerShader(
                borderRadius: borderRadius.topLeft.x,
                borderWidth: borderWidth,
                child: Material(
                  type: MaterialType.transparency,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShimmerShader extends HookWidget {
  const ShimmerShader({
    super.key,
    required this.borderRadius,
    required this.borderWidth,
    required this.child,
  });

  final double borderRadius;
  final double borderWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (:position, :isActive) = context.cursorPosition;

    final shimmerController = useAnimationController(
      duration: Durations.long4,
    );

    final progress = useAnimation(
      CurvedAnimation(
        parent: shimmerController,
        curve: Curves.easeInOutCubicEmphasized,
        reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
      ),
    );
    final shimmerAlpha = progress;

    useEffect(
      () {
        if (isActive) {
          shimmerController.forward();
        } else {
          shimmerController.reverse();
        }

        return null;
      },
      [isActive],
    );

    return ShaderBuilder(
      // assetKey: 'shaders/shimmer.frag',
      assetKey: 'shaders/border.frag',
      child: IgnorePointer(child: child),
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            final topLeft = switch (context.findRenderObject()) {
              final RenderBox box => box.localToGlobal(Offset.zero),
              _ => Offset.zero,
            };
            // shader
            //   ..setFloatUniforms((uniforms) {
            //     uniforms
            //       ..setSize(size)
            //       ..setOffset(position - topLeft)
            //       ..setFloat(shimmerRadius)
            //       ..setFloat(shimmerAlpha);
            //   })
            //   ..setImageSampler(0, image);
            shader.setFloatUniforms((uniforms) {
              uniforms
                ..setSize(size)
                ..setOffset(position - topLeft)
                ..setFloat(borderRadius)
                ..setFloat(borderWidth)
                ..setFloat(shimmerAlpha);
            });

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
          child: child!,
        );
      },
    );
  }
}
