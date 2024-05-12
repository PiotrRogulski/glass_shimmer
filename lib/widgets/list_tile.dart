import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
    this.onTap,
    this.title,
  });

  final VoidCallback? onTap;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      showBaseBorder: false,
      child: ListTile(
        title: title,
        onTap: onTap,
      ),
    );
  }
}
