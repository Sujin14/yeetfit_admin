// lib/features/settings/views/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_tile.dart';
import '../widgets/section_title.dart';
import '../../../../core/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['onPrimary'])), backgroundColor: AdminTheme.colors['primary']),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const SectionTitle(title: 'Profile & Account'),
        SettingsTile(icon: Icons.person_outline, title: 'Edit Profile', onTap: () => Get.toNamed('/edit-profile')),
        SettingsTile(icon: Icons.lock_outline, title: 'Change Password', onTap: () => Get.toNamed('/change-password')),
        SettingsTile(icon: Icons.logout, title: 'Logout', iconColor: AdminTheme.colors['error'], destructive: true, onTap: controller.confirmLogout),
        const SectionTitle(title: 'Support & Info'),
        SettingsTile(icon: Icons.help_outline, title: 'Help / FAQs', onTap: () => Get.toNamed('/help')),
        SettingsTile(icon: Icons.contact_support, title: 'Contact Support', onTap: () => Get.toNamed('/contact-support')),
        SettingsTile(icon: Icons.info_outline, title: 'About App', onTap: () => Get.toNamed('/about')),
        SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () => Get.toNamed('/privacy-policy')),
        SettingsTile(icon: Icons.description, title: 'Terms of Service', onTap: () => Get.toNamed('/terms')),
        const SizedBox(height: 12),
      ]),
    );
  }
}
