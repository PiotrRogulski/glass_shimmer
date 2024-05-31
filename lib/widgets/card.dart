import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:glass_shimmer/shimmer/shimmer_parameters.dart';
import 'package:glass_shimmer/widgets/border_width.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class ShimmerCard extends HookWidget {
  const ShimmerCard({
    super.key,
    this.onTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final Widget child;

  static const borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BorderWidthBuilder(
      builder: (context, borderWidth, statesController) {
        return Shimmer(
          parameters: BorderShimmer(
            borderWidth: borderWidth,
            borderRadius: borderRadius,
          ),
          child: Material(
            surfaceTintColor: colorScheme.surfaceTint,
            borderRadius: BorderRadius.circular(borderRadius),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Container(
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.15),
                  width: borderWidth,
                ),
              ),
              child: InkWell(
                onTap: onTap,
                statesController: statesController,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
