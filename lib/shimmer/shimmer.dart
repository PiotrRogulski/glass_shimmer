import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glass_shimmer/cursor_position.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    this.borderColor,
    this.borderWidth = 3,
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
                  color: borderColor.withOpacity(showBaseBorder ? 0.25 : 0),
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

class ShimmerShader extends StatelessWidget {
  const ShimmerShader({
    super.key,
    required this.shimmerRadius,
    required this.child,
  });

  final double shimmerRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/shimmer.frag',
      child: IgnorePointer(child: child),
      (context, shader, child) {
        final cursorPosition = context.cursorPosition;
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
                  ..setOffset((context.cursorPosition ?? Offset.zero) - topLeft)
                  ..setFloat(shimmerRadius)
                  ..setFloat(cursorPosition == null ? 0 : 1);
              })
              ..setImageSampler(0, image);

            canvas.drawRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Paint()..shader = shader,
            );
          },
          child: child!,
        );
      },
    );
  }
}
