import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearchToggle;
  final RxBool? showSearchBar;
  final VoidCallback? onSearchToggle;
  final bool showProfileIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showSearchToggle = false,
    this.showSearchBar,
    this.onSearchToggle,
    this.showProfileIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AdminTheme.colors['surface'],
      elevation: 2,
      title: Text(title, style: AdminTheme.textStyles['title']),
      actions: [
        if (showSearchToggle && showSearchBar != null && onSearchToggle != null)
          Obx(
            () => IconButton(
              icon: Icon(
                showSearchBar!.value ? Icons.close : Icons.search,
                color: AdminTheme.colors['primary'],
              ),
              onPressed: onSearchToggle,
              tooltip: 'Search',
            ),
          ),
        if (showProfileIcon)
          IconButton(
            icon: Icon(Icons.person, color: AdminTheme.colors['primary']),
            onPressed: () => Get.toNamed('/settings'),
            tooltip: 'Profile',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
