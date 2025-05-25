import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class EdgeBlur extends StatelessWidget {
  const EdgeBlur({super.key, required this.child});

  final Widget child;

  static const blurHeight = 64.0;
  static const safeAreaPadding = 32.0;

  static EdgeInsets blurPaddingOf(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);

    final effectiveTopHeight = max(blurHeight, safeArea.top + safeAreaPadding);
    final effectiveBottomHeight = max(
      blurHeight,
      safeArea.bottom + safeAreaPadding,
    );

    return EdgeInsets.only(
      top: effectiveTopHeight,
      bottom: effectiveBottomHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets(top: effectiveTopHeight, bottom: effectiveBottomHeight) =
        blurPaddingOf(context);

    return ShaderBuilder(assetKey: 'shaders/blur.frag', child: child, (
      context,
      shader,
      child,
    ) {
      return AnimatedSampler(child: child!, (image, size, canvas) {
        shader
          ..setFloatUniforms((uniforms) {
            uniforms
              ..setSize(size)
              ..setFloat(effectiveTopHeight)
              ..setFloat(effectiveBottomHeight);
          })
          ..setImageSampler(0, image);

        canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
      });
    });
  }
}
