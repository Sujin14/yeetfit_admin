import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/core/widgets/custom_appbar.dart';
import '../controllers/client_list_controller.dart';
import '../widgets/client_list_body.dart';
import '../widgets/client_list_header.dart';

class ClientsListScreen extends StatelessWidget {
  final String goal;
  const ClientsListScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    // Standardize goal to lowercase
    final standardizedGoal = goal.toLowerCase();
    final controller = Get.put(
      ClientListController(standardizedGoal),
      tag: standardizedGoal,
    );

    return Obx(
      () => Column(
        children: [
          CustomAppBar(
            title: standardizedGoal
                .split(' ')
                .map((word) {
                  if (word.isEmpty) return word;
                  return word[0].toUpperCase() + word.substring(1);
                })
                .join(' '), // Display as title case for UI
            showSearchToggle: true,
            showSearchBar: controller.showSearchBar,
            onSearchToggle: controller.toggleSearchBar,
          ),
          ClientsListHeader(
            goal: standardizedGoal,
            showSearch: controller.showSearchBar.value,
          ),
          Expanded(child: ClientsListBody(goal: standardizedGoal)),
        ],
      ),
    );
  }
}
