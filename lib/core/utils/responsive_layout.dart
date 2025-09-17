import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return mobile;
    } else if (width < 1024) {
      return tablet;
    } else {
      return desktop;
    }
  }
}


class LayoutConstants {
  static EdgeInsets get screenPadding => EdgeInsets.all(16.w);
  static double get sectionSpacing => 16.h;
  static double get itemSpacing => 8.h;
}