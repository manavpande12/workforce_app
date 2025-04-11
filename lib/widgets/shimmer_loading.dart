import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workforce_app/theme/color.dart';

/// **Reusable Shimmer Placeholder Widget with Left-to-Right Animation**
class ShimmerLoadingCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerLoadingCard({
    super.key,
    this.height = 150,
    this.width = double.infinity,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? bgrey
          : white, // Background color (light grey)
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? black.withValues(alpha: 0.4)
          : grey, // Moving highlight color (brighter grey)
      direction: ShimmerDirection.ltr, // Moves shimmer left to right
      period: Duration(milliseconds: 1000), // Speed of shimmer animation
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark ? black : white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
