import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/clients/presentation/controllers/plan_controller.dart';
import 'core/controllers/bottom_nav_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/theme.dart';
import 'features/clients/presentation/controllers/client_details_controller.dart';
import 'features/clients/presentation/controllers/client_list_controller.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/dashboard/presentation/controllers/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(ClientListController());
  Get.put(PlanController());
  Get.put(ClientDetailsController());
  Get.put(DashboardController());
  Get.put(BottomNavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 873),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute(),
        getPages: AppRoutes.routes,
        navigatorObservers: [GetObserver(AppRoutes.redirect)],
        theme: AdminTheme.getTheme(),
      ),
    );
  }
}
