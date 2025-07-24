import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/chat/domain/use_cases/get_typing_status.dart';
import 'package:yeetfit_admin/features/chat/domain/use_cases/get_user_profile.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/chat/domain/use_cases/create_or_get_chat.dart';
import '../../features/chat/domain/use_cases/delete_chat.dart';
import '../../features/chat/domain/use_cases/delete_message.dart';
import '../../features/chat/domain/use_cases/get_chat_messages.dart';
import '../../features/chat/domain/use_cases/get_message_status.dart';
import '../../features/chat/domain/use_cases/send_message.dart';
import '../../features/chat/domain/use_cases/update_message_status.dart';
import '../../features/chat/domain/use_cases/update_typing_status.dart';
import '../../features/clients/presentation/bindings/client_details_bindings.dart';
import '../../features/clients/presentation/screens/clients_details_screen.dart';
import '../../features/plan/presentation/controllers/diet_plan_controller.dart.dart';
import '../../features/plan/presentation/controllers/workout_plan_controller.dart';
import '../../features/plan/presentation/screens/plan_form_screen.dart';
import '../../features/plan/presentation/screens/plan_list_screen.dart';
import '../../features/plan/presentation/screens/plan_management_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/chat/data/datasources/firestore_chat_service.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
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
            _registerPlanController();
          }),
        ),
        GetPage(
          name: '/plan-form',
          page: () => const PlanFormScreen(),
          binding: BindingsBuilder(() {
            _registerPlanController();
          }),
        ),
        GetPage(
          name: '/diet-plan-management',
          page: () => const PlanManagementScreen(),
          binding: BindingsBuilder(() {
            _registerPlanController(forceType: 'diet');
          }),
        ),
        GetPage(
          name: '/workout-plan-management',
          page: () => const PlanManagementScreen(),
          binding: BindingsBuilder(() {
            _registerPlanController(forceType: 'workout');
          }),
        ),
        GetPage(
          name: '/client-details/chat',
          page: () => const ChatScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ChatController(
                  getChatMessages: GetChatMessages(ChatRepositoryImpl(FirestoreChatService())),
                  getMessageStatus: GetMessageStatus(ChatRepositoryImpl(FirestoreChatService())),
                  getUserProfile: GetUserProfile(ChatRepositoryImpl(FirestoreChatService())),
                  sendMessage: SendMessage(ChatRepositoryImpl(FirestoreChatService())),
                  createOrGetChat: CreateOrGetChat(ChatRepositoryImpl(FirestoreChatService())),
                  updateTypingStatus: UpdateTypingStatus(ChatRepositoryImpl(FirestoreChatService())),
                  getTypingStatus: GetTypingStatus(ChatRepositoryImpl(FirestoreChatService())),
                  updateMessageStatus: UpdateMessageStatus(ChatRepositoryImpl(FirestoreChatService())),
                  deleteChat: DeleteChat(ChatRepositoryImpl(FirestoreChatService())),
                  deleteMessage: DeleteMessage(ChatRepositoryImpl(FirestoreChatService())),
                ));
          }),
        ),
      ],
    ),
  ];

  static void _registerPlanController({String? forceType}) {
    final args = Get.arguments ?? {};
    final uid = args['uid'] ?? '';
    final type = forceType ?? args['type'];
    final tag = 'plan-$uid-$type';

    if (uid.isEmpty || type == null) return;

    if (type == 'diet' && !Get.isRegistered<DietPlanController>(tag: tag)) {
      final controller = DietPlanController();
      controller.setupWithArguments(args);
      Get.put<DietPlanController>(controller, tag: tag);
    } else if (type == 'workout' && !Get.isRegistered<WorkoutPlanController>(tag: tag)) {
      final controller = WorkoutPlanController();
      controller.setupWithArguments(args);
      Get.put<WorkoutPlanController>(controller, tag: tag);
    } else {
      final controller = type == 'diet'
          ? Get.find<DietPlanController>(tag: tag)
          : Get.find<WorkoutPlanController>(tag: tag);
      controller.setupWithArguments(args);
    }
  }

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