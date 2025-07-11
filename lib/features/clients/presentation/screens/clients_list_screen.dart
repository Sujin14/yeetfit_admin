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
    // Register controller with tag for this goal
    final controller = Get.put(ClientListController(goal), tag: goal);

    return Obx(
      () => Column(
        children: [
          CustomAppBar(
            title: goal,
            showSearchToggle: true,
            showSearchBar: controller.showSearchBar,
            onSearchToggle: controller.toggleSearchBar,
          ),
          ClientsListHeader(
            goal: goal,
            showSearch: controller.showSearchBar.value,
          ),
          Expanded(child: ClientsListBody(goal: goal)),
        ],
      ),
    );
  }
}
