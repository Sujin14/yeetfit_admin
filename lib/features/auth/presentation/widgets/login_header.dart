import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Admin Login",
      style: AdminTheme.textStyles['title']!.copyWith(
        fontSize: 20.sp,
        color: AdminTheme.colors['primary'],
      ),
    );
  }
}
