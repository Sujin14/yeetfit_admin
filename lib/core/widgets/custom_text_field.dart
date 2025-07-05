import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final String? hintText;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AdminTheme.textStyles['body']!.copyWith(
            color: AdminTheme.colors['textSecondary'],
          ),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AdminTheme.colors['primary']!),
          ),
        ),
        style: AdminTheme.textStyles['body'],
        validator: validator,
      ),
    );
  }
}
