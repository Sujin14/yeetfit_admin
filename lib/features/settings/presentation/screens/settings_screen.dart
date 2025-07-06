import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/settings_option.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(
          () => authController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SettingsOption(
                      title: 'Sign Out',
                      icon: Icons.logout,
                      onTap: () async {
                        final confirmed =
                            await Get.dialog<bool>(
                              AlertDialog(
                                title: const Text('Confirm Sign Out'),
                                content: const Text(
                                  'Are you sure you want to sign out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color:
                                            AdminTheme.colors['textSecondary'],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(result: true),
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: AdminTheme.colors['error'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) ??
                            false;

                        if (confirmed) {
                          await authController.logout();
                        }
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
