import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/plan_model.dart';
import '../controllers/client_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlanAssignmentForm extends GetView<ClientController> {
  const PlanAssignmentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final typeController = TextEditingController();
    final detailsController = TextEditingController();
    final isWorkout = true.obs;

    return Obx(
      () => Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assign Plan', style: AdminTheme.textStyles['title']),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Plan Type',
                    labelStyle: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['textSecondary'],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: ['Workout', 'Diet']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    isWorkout.value = value == 'Workout';
                    typeController.text = value!.toLowerCase();
                  },
                  validator: FormValidators.validatePlanType,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: detailsController,
                  labelText: isWorkout.value
                      ? 'Exercises (JSON)'
                      : 'Meals (JSON)',
                  maxLines: 3,
                  hintText: isWorkout.value
                      ? '[{"name": "Push-ups", "reps": 10, "sets": 3}]'
                      : '{"breakfast": [{"food": "Oatmeal", "calories": 200}]}',
                  validator: FormValidators.validatePlanDetails,
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  text: 'Assign Plan',
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final uid = Get.arguments['uid'];
                      final plan = PlanModel(
                        userId: uid,
                        type: typeController.text,
                        details: isWorkout.value
                            ? {
                                'exercises': [
                                  {
                                    'name': detailsController.text,
                                    'reps': 10,
                                    'sets': 3,
                                  },
                                ],
                              }
                            : {
                                'breakfast': [
                                  {
                                    'food': detailsController.text,
                                    'calories': 200,
                                  },
                                ],
                              },
                        assignedBy: FirebaseAuth.instance.currentUser!.uid,
                        createdAt: DateTime.now(),
                      );
                      final success = await controller.assignClientPlan(
                        uid,
                        plan,
                      );
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Success',
                          '${typeController.text.capitalizeFirst} plan assigned',
                          backgroundColor: AdminTheme.colors['primary'],
                          colorText: AdminTheme.colors['surface'],
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Failed to assign ${typeController.text} plan',
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
