import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/client_controller.dart';

class ClientDetailsController extends GetxController {
  final ClientController clientController = Get.find<ClientController>();
  final uid = ''.obs;
  final clientName = Rxn<String>();
  final isInvalidUid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() {
    final argsUid = Get.arguments?['uid'] as String?;
    if (argsUid == null || argsUid.isEmpty) {
      isInvalidUid.value = true;
      return;
    }
    uid.value = argsUid;
    clientName.value = clientController.selectedClient.value?.name;

    // Fetch client details after the build phase if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clientController.selectedClient.value == null ||
          clientController.selectedClient.value!.uid != uid.value) {
        clientController.fetchClientDetails(uid.value);
      }
    });

    // Listen for changes to selectedClient to update name
    ever(clientController.selectedClient, (client) {
      clientName.value = client?.name;
    });
  }

  void navigateToDietPlanForm() {
    if (!isInvalidUid.value) {
      Get.toNamed('/home/diet-plan-form', arguments: {'uid': uid.value});
    }
  }

  void navigateToWorkoutPlanForm() {
    if (!isInvalidUid.value) {
      Get.toNamed('/home/workout-plan-form', arguments: {'uid': uid.value});
    }
  }
}
