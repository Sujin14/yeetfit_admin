import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String text;
  const EmptyPlaceholder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          text,
          style: AdminTheme.textStyles['body']!.copyWith(
            color: AdminTheme.colors['textSecondary'],
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
