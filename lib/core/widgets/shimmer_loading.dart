import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AdminTheme.colors['black']!,
      highlightColor: AdminTheme.colors['surface']!,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}