import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.onTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Shimmer(
      border: (
        color: colorScheme.onSurface,
        width: 3,
        radius: borderRadius,
      ),
      child: Material(
        surfaceTintColor: colorScheme.surfaceTint,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
