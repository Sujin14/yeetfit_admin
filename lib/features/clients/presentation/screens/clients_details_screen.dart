import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_body.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInvalidUid.value) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Error'),
          body: Center(child: Text(controller.error.value)),
        );
      }
      return Scaffold(
        appBar: CustomAppBar(
          title: controller.clientName.value.isEmpty
              ? 'Client Details'
              : controller.clientName.value,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => AppRoutes.debounceNavigate(
            '/home/client-details/chat',
            arguments: {
              'participantId': controller.uid.value,
              'participantName': controller.clientName.value,
              'participantImage': controller.client.value?.profilePicture ?? '',
            },
          ),
          backgroundColor: AdminTheme.colors['primary'],
          child: Icon(Icons.chat, color: AdminTheme.colors['onPrimary']),
        ),
        body: const ClientDetailsBody(),
      );
    });
  }
}
