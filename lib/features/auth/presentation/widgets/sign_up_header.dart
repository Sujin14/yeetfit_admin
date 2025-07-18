import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Create Admin Account",
      style: AdminTheme.textStyles['title']!.copyWith(
        fontSize: 22.sp,
        color: AdminTheme.colors['primary'],
      ),
    );
  }
}
