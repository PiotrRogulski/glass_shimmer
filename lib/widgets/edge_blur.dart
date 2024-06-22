import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class EdgeBlur extends StatelessWidget {
  const EdgeBlur({
    super.key,
    required this.child,
  });

  final Widget child;

  static const topHeight = 64.0;
  static const bottomHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/blur.frag',
      child: child,
      (context, shader, child) {
        return AnimatedSampler(
          child: child!,
          (image, size, canvas) {
            shader
              ..setFloatUniforms((uniforms) {
                uniforms
                  ..setSize(size)
                  ..setFloat(topHeight)
                  ..setFloat(bottomHeight);
              })
              ..setImageSampler(0, image);

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
        );
      },
    );
  }
}
