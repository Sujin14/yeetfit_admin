import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_widget.dart';

class AuthNavLink extends StatelessWidget {
  final String prefixText;
  final String linkText;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const AuthNavLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onPressed,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: TextButton(
        onPressed: onPressed,
        child: RichText(
          text: TextSpan(
            style: AdminTheme.textStyles['body'],
            children: [
              TextSpan(text: prefixText),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GradientText(
                  text: linkText,
                  style: AdminTheme.textStyles['title']!,
                  gradient: LinearGradient(colors: gradientColors),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}