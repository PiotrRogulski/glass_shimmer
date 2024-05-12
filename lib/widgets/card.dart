import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class ShimmerCard extends HookWidget {
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

    final statesController = useMaterialStatesController();

    return Shimmer(
      borderRadius: borderRadius,
      statesController: statesController,
      child: Material(
        surfaceTintColor: colorScheme.surfaceTint,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          statesController: statesController,
          child: child,
        ),
      ),
    );
  }
}
