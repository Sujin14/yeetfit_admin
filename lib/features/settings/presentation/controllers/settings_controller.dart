import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SettingsController extends GetxController {
  final authController = Get.find<AuthController>();
  final user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.userChanges().listen((u) => user.value = u);
  }

  void confirmLogout() {
    Get.defaultDialog(
      title: 'Confirm Logout',
      middleText: 'Are you sure you want to log out?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: AdminTheme.colors['onPrimary'],
      onConfirm: () async {
        Get.back();
        await authController.logout();
      },
    );
  }
}
