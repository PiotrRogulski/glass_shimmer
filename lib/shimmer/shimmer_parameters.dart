import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

enum ShimmerSurface<T extends ShimmerParameters> {
  border('shaders/border.frag'),
  pillow('shaders/pillow_rect.frag'),
  sphere('shaders/sphere.frag'),
  ;

  const ShimmerSurface(this.assetKey);

  final String assetKey;
}

sealed class ShimmerParameters {
  const ShimmerParameters(this.surface);

  final ShimmerSurface surface;

  @nonVirtual
  void setupUniforms(
    UniformsSetter uniforms, {
    required Size size,
    required Offset cursorPosition,
    required double alpha,
    required double elevation,
  }) {
    uniforms
      ..setSize(size)
      ..setOffset(cursorPosition)
      ..setFloat(alpha)
      ..setFloat(elevation);
    _setupAdditionalUniforms(uniforms);
  }

  void _setupAdditionalUniforms(UniformsSetter uniforms) {}
}

final class BorderShimmer extends ShimmerParameters {
  const BorderShimmer({
    required this.borderWidth,
    required this.borderRadius,
  }) : super(ShimmerSurface.border);

  final double borderWidth;
  final double borderRadius;

  @override
  void _setupAdditionalUniforms(UniformsSetter uniforms) => uniforms
    ..setFloat(borderRadius)
    ..setFloat(borderWidth);
}

final class PillowShimmer extends ShimmerParameters {
  const PillowShimmer() : super(ShimmerSurface.pillow);
}

final class SphereShimmer extends ShimmerParameters {
  const SphereShimmer() : super(ShimmerSurface.sphere);
}
