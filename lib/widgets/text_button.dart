import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:glass_shimmer/shimmer/shimmer_parameters.dart';
import 'package:glass_shimmer/widgets/border_state.dart';

class ShimmerTextButton extends StatelessWidget {
  const ShimmerTextButton({
    super.key,
    this.onTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final Widget child;

  static const borderRadius = 0.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BorderStateBuilder(
      builder: (context, borderWidth, elevation, statesController) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Shimmer(
            parameters: const PillowShimmer(),
            elevation: elevation,
            child: Material(
              surfaceTintColor: colorScheme.surfaceTint,
              borderRadius: BorderRadius.circular(borderRadius),
              clipBehavior: Clip.antiAlias,
              elevation: 2,
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
