import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/clients/presentation/screens/clients_details_screen.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../../features/clients/presentation/screens/diet_plan_form_screen.dart';
import '../../features/clients/presentation/screens/workout_plan_form_screen.dart';
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
          name: '/diet-plan-form',
          page: () => const DietPlanFormScreen(),
        ),
        GetPage(
          name: '/workout-plan-form',
          page: () => const WorkoutPlanFormScreen(),
        ),
      ],
    ),
  ];

  static Future<String?> redirect(Routing? routing) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in, redirecting to /');
      return '/';
    }

    final controller = Get.find<AuthController>();
    final isAdmin = await controller.isAdmin(user.uid);
    if (!isAdmin) {
      print(
        'User ${user.uid} is not an admin, signing out and redirecting to /',
      );
      await FirebaseAuth.instance.signOut();
      return '/';
    }

    if (routing?.current == '/' || routing?.current == '/signup') {
      print('Admin user, redirecting to /home');
      return '/home';
    }

    print('Allowing navigation to ${routing?.current}');
    return null;
  }
}
