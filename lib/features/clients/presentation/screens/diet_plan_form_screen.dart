import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/plan_model.dart';
import '../controllers/client_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietPlanFormScreen extends GetView<ClientController> {
  const DietPlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = Get.arguments?['uid'] as String?;
    final formKey = GlobalKey<FormState>();
    final mealController = TextEditingController();
    final caloriesController = TextEditingController();

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: 'Assign Diet Plan',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AdminTheme.colors['textPrimary'],
              size: 24.w,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Meal', style: AdminTheme.textStyles['title']),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: mealController,
                  labelText: 'Meal Name',
                  validator: FormValidators.validatePlanDetails,
                ),
                CustomTextField(
                  controller: caloriesController,
                  labelText: 'Calories (kcal)',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      FormValidators.validateNumber(value, 'Calories'),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Assign Diet Plan',
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final plan = PlanModel(
                        userId: uid ?? '',
                        type: 'diet',
                        details: {
                          'meals': [
                            {
                              'food': mealController.text,
                              'calories': int.parse(caloriesController.text),
                            },
                          ],
                        },
                        assignedBy: FirebaseAuth.instance.currentUser!.uid,
                        createdAt: DateTime.now(),
                      );
                      final success = await controller.assignClientPlan(
                        uid!,
                        plan,
                      );
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Diet plan assigned',
                          backgroundColor: AdminTheme.colors['primary'],
                          colorText: AdminTheme.colors['surface'],
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Failed to assign diet plan',
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['surface'],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
