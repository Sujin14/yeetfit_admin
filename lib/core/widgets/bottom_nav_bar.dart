import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = 0.obs;

    Widget getSelectedScreen(int index) {
      switch (index) {
        case 0:
          return const DashboardScreen();
        case 1:
          return const ClientsListScreen();
        case 2:
          return const SettingsScreen();
        default:
          return const DashboardScreen();
      }
    }

    return Obx(
      () => Scaffold(
        body: getSelectedScreen(selectedIndex.value),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) => selectedIndex.value = index,
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.dashboard,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.dashboard,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.people,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.people,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Clients',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings,
                color: AdminTheme.colors['textSecondary'],
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: AdminTheme.colors['primary'],
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
