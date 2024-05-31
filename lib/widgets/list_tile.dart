import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:glass_shimmer/shimmer/shimmer_parameters.dart';
import 'package:glass_shimmer/widgets/border_width.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class ShimmerListTile extends HookWidget {
  const ShimmerListTile({
    super.key,
    this.onTap,
    this.title,
  });

  final VoidCallback? onTap;
  final Widget? title;

  static const borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return BorderWidthBuilder(
      builder: (context, borderWidth, statesController) {
        return Shimmer(
          parameters: BorderShimmer(
            borderWidth: borderWidth,
            borderRadius: borderRadius,
          ),
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: onTap,
              statesController: statesController,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!,
                  child: title ?? const SizedBox(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
