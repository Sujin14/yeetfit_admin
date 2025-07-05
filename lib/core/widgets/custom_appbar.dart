import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;

  const CustomAppBar({super.key, required this.title, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AdminTheme.textStyles['title'],
        textAlign: TextAlign.center,
      ),
      leading: leading,
      backgroundColor: AdminTheme.colors['surface'],
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
