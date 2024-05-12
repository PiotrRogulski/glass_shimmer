import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glass_shimmer/cursor_position.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    required this.border,
    required this.child,
  });

  final ({Color color, double width, BorderRadius radius}) border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Material(
              type: MaterialType.transparency,
              shape: RoundedRectangleBorder(
                borderRadius: border.radius,
                side: BorderSide(
                  color: border.color.withOpacity(0.25),
                  width: border.width,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ShimmerShader(
            shimmerRadius: 50,
            child: Material(
              color: border.color.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: border.radius),
            ),
          ),
        ),
        Positioned.fill(
          child: ShimmerShader(
            shimmerRadius: 100,
            child: Material(
              type: MaterialType.transparency,
              shape: RoundedRectangleBorder(
                borderRadius: border.radius,
                side: BorderSide(
                  color: border.color.withOpacity(0.75),
                  width: border.width,
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
        return AnimatedSampler(
          (image, size, canvas) {
            final topLeft = switch (context.findRenderObject()) {
              final RenderBox box => box.localToGlobal(Offset.zero),
              _ => Offset.zero,
            };
            final cursorPosition =
                (context.cursorPosition ?? Offset.zero) - topLeft;
            shader
              ..setFloatUniforms((uniforms) {
                uniforms
                  ..setSize(size)
                  ..setOffset(cursorPosition)
                  ..setFloat(shimmerRadius);
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
