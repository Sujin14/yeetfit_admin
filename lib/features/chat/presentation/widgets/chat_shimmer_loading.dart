import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/theme.dart';

Widget chatShimmerLoading() {
  return ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: AdminTheme.colors['black']!.withOpacity(0.2),
      highlightColor: AdminTheme.colors['surface']!.withOpacity(0.4),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Align(
          alignment: index % 2 == 0
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            width: 200.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AdminTheme.colors['surface'],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    ),
  );
}
