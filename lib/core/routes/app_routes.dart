import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/clients/presentation/controllers/plan_controller.dart';
import '../../features/clients/presentation/screens/clients_details_screen.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../../features/clients/presentation/screens/plan_form_screen.dart';
import '../../features/clients/presentation/screens/plan_management_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class AppRoutes {
  static String initialRoute() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? '/home' : '/';
  }

  static final routes = [
    GetPage(name: '/', page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(
      name: '/home',
      page: () => const BottomNavBar(),
      children: [
        GetPage(name: '/clients', page: () => const ClientsListScreen()),
        GetPage(
          name: '/client-details',
          page: () => const ClientDetailsScreen(),
        ),
        GetPage(
          name: '/plan-form',
          page: () => const PlanFormScreen(),
          binding: BindingsBuilder(() {
            print('AppRoutes: Binding PlanController for /home/plan-form');
            Get.put(PlanController());
          }),
        ),
        GetPage(
          name: '/diet-plan-management',
          page: () => const PlanManagementScreen(),
        ),
        GetPage(
          name: '/workout-plan-management',
          page: () => const PlanManagementScreen(),
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

    // Redirect only for root routes '/' or '/signup'
    if (currentRoute == '/' || currentRoute == '/signup') {
      print('AppRoutes.redirect: Admin user, redirecting to /home');
      return '/home';
    }

    // Allow nested routes to proceed without interference
    print(
      'AppRoutes.redirect: Allowing navigation to $currentRoute with arguments: $arguments',
    );
    return null;
  }
}
