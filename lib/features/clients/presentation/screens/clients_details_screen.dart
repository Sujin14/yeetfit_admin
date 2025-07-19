import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_body.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInvalidUid.value) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text(controller.error.value)),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.clientName.value.isEmpty
              ? 'Client Details'
              : controller.clientName.value),
        ),
        body: const ClientDetailsBody(),
      );
    });
  }
}
