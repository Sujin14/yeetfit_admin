import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../theme/theme.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    Widget getSelectedScreen(int index) {
      switch (index) {
        case 0:
          return const ClientsListScreen(goal: 'Weight Loss');
        case 1:
          return const ClientsListScreen(goal: 'Weight Gain');
        case 2:
          return const ClientsListScreen(goal: 'Muscle Building');
        default:
          return const ClientsListScreen(goal: 'Weight Loss');
      }
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.selectedIndex.value == 0
                ? 'Weight Loss Clients'
                : controller.selectedIndex.value == 1
                ? 'Weight Gain Clients'
                : 'Muscle Building Clients',
            style: AdminTheme.textStyles['title'],
          ),
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.person, color: AdminTheme.colors['primary']),
              onPressed: () => Get.toNamed('/settings'),
            ),
          ],
        ),
        body: getSelectedScreen(controller.selectedIndex.value),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.changeIndex(index),
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.fitness_center,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.fitness_center,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Weight Loss',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.trending_up,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.trending_up,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Weight Gain',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.accessibility_new,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.accessibility_new,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Muscle Building',
            ),
          ],
        ),
      ),
    );
  }
}
