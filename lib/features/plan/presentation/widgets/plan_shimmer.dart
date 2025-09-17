import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class PlanShimmer extends StatelessWidget {
  const PlanShimmer({super.key});

  Widget _shimmerField({double height = 50, double widthFactor = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ShimmerLoading(
        height: height.h,
        width: ScreenUtil().screenWidth * widthFactor,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerField(),
        _shimmerField(height: 80),
        _shimmerField(),
        _shimmerField(height: 50, widthFactor: 0.6),
        _shimmerField(),
        _shimmerField(),
        _shimmerField(),
        _shimmerField(height: 30, widthFactor: 0.3),
        _shimmerField(),
        _shimmerField(height: 45, widthFactor: 0.4),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerLoading(height: 45.h, width: 120.w, borderRadius: BorderRadius.circular(8.r)),
            ShimmerLoading(height: 45.h, width: 120.w, borderRadius: BorderRadius.circular(8.r)),
          ],
        ),
      ],
    );
  }
}
