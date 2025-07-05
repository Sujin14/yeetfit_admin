import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../data/models/plan_model.dart';
import '../controllers/plan_controller.dart';
import '../widgets/plan_form_fields.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';

class PlanFormScreen extends GetView<PlanController> {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = Get.arguments?['uid'] as String?;
    final mode = Get.arguments?['mode'] as String? ?? 'add';
    final plan = Get.arguments?['plan'] as PlanModel?;
    final type = Get.arguments?['type'] as String? ?? 'diet';

    return Scaffold(
      appBar: CustomAppBar(
        title: mode == 'add'
            ? 'Add ${type.capitalizeFirstLetter} Plan'
            : 'Edit ${type.capitalizeFirstLetter} Plan',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AdminTheme.colors['textPrimary'],
            size: 24.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: PlanFormFields(
        controller: controller,
        uid: uid ?? '',
        mode: mode,
        plan: plan,
        type: type,
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String get capitalizeFirstLetter =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
