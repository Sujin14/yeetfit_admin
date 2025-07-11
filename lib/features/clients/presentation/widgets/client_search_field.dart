import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/client_list_controller.dart';

class ClientsSearchBar extends StatelessWidget {
  final String goal;
  const ClientsSearchBar({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientListController>(tag: goal);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: TextStyle(color: AdminTheme.colors['textSecondary']),
          prefixIcon: Icon(Icons.search, color: AdminTheme.colors['primary']),
          filled: true,
          fillColor: AdminTheme.colors['inputBackground'],
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
