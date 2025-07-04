import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/settings_option.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            SettingsOption(
              title: 'Sign Out',
              icon: Icons.logout,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
