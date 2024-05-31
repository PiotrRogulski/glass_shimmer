import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

enum ShimmerSurface<T extends ShimmerParameters> {
  border('shaders/border.frag'),
  pillow('shaders/pillow_rect.frag'),
  ;

  const ShimmerSurface(this.assetKey);

  final String assetKey;
}

sealed class ShimmerParameters {
  const ShimmerParameters(this.surface);

  final ShimmerSurface surface;

  @mustCallSuper
  void setupUniforms(
    UniformsSetter uniforms, {
    required Size size,
    required Offset cursorPosition,
    required double alpha,
  }) {
    uniforms
      ..setSize(size)
      ..setOffset(cursorPosition)
      ..setFloat(alpha);
  }
}

final class BorderShimmer extends ShimmerParameters {
  const BorderShimmer({
    required this.borderWidth,
    required this.borderRadius,
  }) : super(ShimmerSurface.border);

  final double borderWidth;
  final double borderRadius;

  @override
  void setupUniforms(
    UniformsSetter uniforms, {
    required Size size,
    required Offset cursorPosition,
    required double alpha,
  }) {
    super.setupUniforms(
      uniforms,
      size: size,
      cursorPosition: cursorPosition,
      alpha: alpha,
    );
    uniforms
      ..setFloat(borderRadius)
      ..setFloat(borderWidth);
  }
}

final class PillowShimmer extends ShimmerParameters {
  const PillowShimmer() : super(ShimmerSurface.pillow);
}
