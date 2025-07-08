import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/client_details_controller.dart';
import 'client_details_card.dart';

class ClientDetailsCardWrapper extends StatelessWidget {
  const ClientDetailsCardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    return ClientDetailsCard(client: controller.selectedClient.value!);
  }
}
