import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class ShimmerListTile extends HookWidget {
  const ShimmerListTile({
    super.key,
    this.onTap,
    this.title,
  });

  final VoidCallback? onTap;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final statesController = useMaterialStatesController();

    const borderRadius = BorderRadius.all(Radius.circular(12));

    return Shimmer(
      showBaseBorder: false,
      statesController: statesController,
      borderRadius: borderRadius,
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius,
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
  }
}
