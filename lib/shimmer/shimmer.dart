import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glass_shimmer/cursor_position.dart';
import 'package:glass_shimmer/shimmer/shimmer_parameters.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class Shimmer<T extends ShimmerParameters> extends StatelessWidget {
  const Shimmer({
    super.key,
    required this.parameters,
    required this.child,
  });

  final T parameters;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: ShimmerShader(
            parameters: parameters,
            child: const Material(
              type: MaterialType.transparency,
            ),
          ),
        ),
      ],
    );
  }
}

class ShimmerShader<T extends ShimmerParameters> extends HookWidget {
  const ShimmerShader({
    super.key,
    required this.parameters,
    required this.child,
  });

  final T parameters;
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
      assetKey: parameters.surface.assetKey,
      child: IgnorePointer(child: child),
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            final topLeft = switch (context.findRenderObject()) {
              final RenderBox box => box.localToGlobal(Offset.zero),
              _ => Offset.zero,
            };
            shader.setFloatUniforms((uniforms) {
              parameters.setupUniforms(
                uniforms,
                size: size,
                cursorPosition: position - topLeft,
                alpha: shimmerAlpha,
              );
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
