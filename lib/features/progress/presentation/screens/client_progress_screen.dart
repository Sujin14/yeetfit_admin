import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/client_progress_controller.dart';
import '../widgets/client_progress_body.dart';


class ClientProgressScreen extends GetView<ClientProgressController> {
  const ClientProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Progress'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: AdminTheme.colors['primary']),
            onPressed: () => controller.pickDate(context),
          ),
        ],
      ),
      body: const ClientProgressBody(),
    );
  }
}