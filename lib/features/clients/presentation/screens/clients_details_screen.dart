import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_body.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              controller.clientName.value.isEmpty ? 'Client Details' : controller.clientName.value,
              style: AdminTheme.textStyles['title']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
              ),
            ),
            backgroundColor: AdminTheme.colors['surface'],
            elevation: 2,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AdminTheme.colors['textPrimary']),
              onPressed: () => Get.back(),
            ),
          ),
          body: const ClientDetailsBody(),
        ));
  }
}
