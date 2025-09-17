import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? text;
  final TextStyle? textStyle;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.text,
    this.textStyle,
  });

  /// Named constructor for text shimmer
  factory ShimmerLoading.text({
    Key? key,
    required String text,
    required TextStyle textStyle,
  }) {
    return ShimmerLoading(
      key: key,
      text: text,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AdminTheme.colors['accent']!,
      highlightColor: AdminTheme.colors['surface']!,
      child: text != null
          ? Text(
              text!,
              style: textStyle?.copyWith(color: AdminTheme.colors['white']),
            )
          : Container(
              width: width ?? double.infinity,
              height: height ?? 50.h,
              decoration: BoxDecoration(
                color: AdminTheme.colors['accent'],
                borderRadius: borderRadius ?? BorderRadius.circular(8.r),
              ),
            ),
    );
  }
}
