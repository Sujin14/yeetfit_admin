import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminTheme.colors['primary'],
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: isLoading
          ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                color: AdminTheme.colors['surface'],
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: AdminTheme.textStyles['button']!.copyWith(
                color: AdminTheme.colors['surface'],
              ),
            ),
    );
  }
}
