import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/clients/presentation/bindings/client_details_bindings.dart';
import '../../features/clients/presentation/controllers/plan_controller.dart';
import '../../features/clients/presentation/screens/clients_details_screen.dart';
import '../../features/clients/presentation/screens/plan_form_screen.dart';
import '../../features/clients/presentation/screens/plan_management_screen.dart';
import '../../features/clients/presentation/screens/plan_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class AppRoutes {
  static String initialRoute() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? '/home' : '/';
  }

  static final routes = [
    GetPage(name: '/', page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(name: '/settings', page: () => const SettingsScreen()),
    GetPage(
      name: '/home',
      page: () => const BottomNavBar(),
      children: [
        GetPage(
          name: '/client-details',
          page: () => const ClientDetailsScreen(),
          binding: ClientDetailsBinding(),
        ),
        GetPage(
          name: '/plan-list',
          page: () {
            final args = Get.arguments;
            return PlanListScreen(uid: args['uid'], type: args['type']);
          },
          binding: BindingsBuilder(() {
            final args = Get.arguments;
            final uid = args['uid'];
            final type = args['type'];
            final tag = 'plan-$uid-$type';
            if (!Get.isRegistered<PlanController>(tag: tag)) {
              final controller = PlanController();
              controller.setupWithArguments(args);
              Get.put(controller, tag: tag);
            } else {
              final controller = Get.find<PlanController>(tag: tag);
              controller.setupWithArguments(args);
            }
          }),
        ),

        GetPage(
          name: '/plan-form',
          page: () => const PlanFormScreen(),
          binding: BindingsBuilder(() {
            final args = Get.arguments;
            final tag = 'plan-${args['uid']}-${args['type']}';
            if (!Get.isRegistered<PlanController>(tag: tag)) {
              final controller = PlanController();
              controller.setupWithArguments(args);
              Get.put(controller, tag: tag);
            } else {
              final controller = Get.find<PlanController>(tag: tag);
              controller.setupWithArguments(args);
            }
          }),
        ),
        GetPage(
          name: '/diet-plan-management',
          page: () => const PlanManagementScreen(),
          binding: BindingsBuilder(() {
            final args = Get.arguments;
            final uid = args['uid'];
            final type = 'diet';
            final tag = 'plan-$uid-$type';
            if (!Get.isRegistered<PlanController>(tag: tag)) {
              final controller = PlanController();
              controller.setupWithArguments(args);
              Get.put(controller, tag: tag);
            } else {
              final controller = Get.find<PlanController>(tag: tag);
              controller.setupWithArguments(args);
            }
          }),
        ),
        GetPage(
          name: '/workout-plan-management',
          page: () => const PlanManagementScreen(),
          binding: BindingsBuilder(() {
            final args = Get.arguments;
            final uid = args['uid'];
            final type = 'workout';
            final tag = 'plan-$uid-$type';
            if (!Get.isRegistered<PlanController>(tag: tag)) {
              final controller = PlanController();
              controller.setupWithArguments(args);
              Get.put(controller, tag: tag);
            } else {
              final controller = Get.find<PlanController>(tag: tag);
              controller.setupWithArguments(args);
            }
          }),
        ),
      ],
    ),
  ];

  static Future<String?> redirect(Routing? routing) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentRoute = routing?.current ?? '';
    final arguments = Get.arguments;
    print(
      'AppRoutes.redirect: Current route: $currentRoute, Arguments: $arguments',
    );

    if (user == null) {
      print('AppRoutes.redirect: No user logged in, redirecting to /');
      return '/';
    }

    final controller = Get.find<AuthController>();
    final isAdmin = await controller.isAdmin(user.uid);
    if (!isAdmin) {
      print(
        'AppRoutes.redirect: User ${user.uid} is not an admin, signing out and redirecting to /',
      );
      await FirebaseAuth.instance.signOut();
      return '/';
    }

    if (currentRoute == '/' || currentRoute == '/signup') {
      print('AppRoutes.redirect: Admin user, redirecting to /home');
      return '/home';
    }

    print('AppRoutes.redirect: Allowing navigation to $currentRoute');
    return null;
  }
}
