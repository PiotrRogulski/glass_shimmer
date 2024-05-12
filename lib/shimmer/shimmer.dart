import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glass_shimmer/cursor_position.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    this.borderColor,
    this.borderWidth = 2,
    this.borderRadius = BorderRadius.zero,
    this.showBaseBorder = true,
    required this.child,
  });

  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final bool showBaseBorder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = this.borderColor ?? colorScheme.onSurface;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Material(
              type: MaterialType.transparency,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(
                  color: borderColor.withOpacity(showBaseBorder ? 0.15 : 0),
                  width: borderWidth,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ShimmerShader(
            shimmerRadius: 50,
            child: Material(
              color: borderColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
        Positioned.fill(
          child: ShimmerShader(
            shimmerRadius: 150,
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
          ),
        ),
      ],
    );
  }
}

class ShimmerShader extends HookWidget {
  const ShimmerShader({
    super.key,
    required this.shimmerRadius,
    required this.child,
  });

  final double shimmerRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (:position, :isActive) = context.cursorPosition;

    final shimmerController = useAnimationController(
      duration: Durations.medium4,
    );

    final progress = useAnimation(
      CurvedAnimation(
        parent: shimmerController,
        curve: Easing.standard,
        reverseCurve: Easing.standard.flipped,
      ),
    );
    final shimmerRadius = this.shimmerRadius * progress;
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
      assetKey: 'shaders/shimmer.frag',
      child: IgnorePointer(child: child),
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            final topLeft = switch (context.findRenderObject()) {
              final RenderBox box => box.localToGlobal(Offset.zero),
              _ => Offset.zero,
            };
            shader
              ..setFloatUniforms((uniforms) {
                uniforms
                  ..setSize(size)
                  ..setOffset(position - topLeft)
                  ..setFloat(shimmerRadius)
                  ..setFloat(shimmerAlpha);
              })
              ..setImageSampler(0, image);

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
