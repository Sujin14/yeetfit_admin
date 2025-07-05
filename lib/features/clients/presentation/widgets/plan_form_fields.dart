import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yeetfit_admin/features/clients/presentation/screens/plan_form_screen.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/plan_model.dart';
import '../controllers/plan_controller.dart';

class PlanFormFields extends StatelessWidget {
  final PlanController controller;
  final String uid;
  final String mode;
  final PlanModel? plan;
  final String type;

  const PlanFormFields({
    super.key,
    required this.controller,
    required this.uid,
    required this.mode,
    this.plan,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: plan?.title ?? '');
    final nameController = TextEditingController(
      text:
          plan?.details[type == 'diet' ? 'meals' : 'exercises']?[0]['food']
              ?.toString() ??
          plan?.details[type == 'diet' ? 'meals' : 'exercises']?[0]['name']
              ?.toString() ??
          '',
    );
    final numberController = TextEditingController(
      text:
          plan
              ?.details[type == 'diet'
                  ? 'meals'
                  : 'exercises']?[0][type == 'diet' ? 'calories' : 'reps']
              ?.toString() ??
          '',
    );
    final setsController = TextEditingController(
      text: plan?.details['exercises']?[0]['sets']?.toString() ?? '',
    );

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plan Details', style: AdminTheme.textStyles['title']),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: titleController,
                labelText: 'Plan Title',
                validator: FormValidators.validatePlanDetails,
              ),
              CustomTextField(
                controller: nameController,
                labelText: type == 'diet' ? 'Meal Name' : 'Exercise Name',
                validator: FormValidators.validatePlanDetails,
              ),
              CustomTextField(
                controller: numberController,
                labelText: type == 'diet' ? 'Calories (kcal)' : 'Reps',
                keyboardType: TextInputType.number,
                validator: (value) => FormValidators.validateNumber(
                  value,
                  type == 'diet' ? 'Calories' : 'Reps',
                ),
              ),
              if (type == 'workout') ...[
                CustomTextField(
                  controller: setsController,
                  labelText: 'Sets',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      FormValidators.validateNumber(value, 'Sets'),
                ),
              ],
              SizedBox(height: 24.h),
              CustomButton(
                text: mode == 'add'
                    ? 'Assign ${type.capitalizeFirstLetter} Plan'
                    : 'Update ${type.capitalizeFirstLetter} Plan',
                isLoading: controller.isLoading.value,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final numberValue =
                          int.tryParse(numberController.text) ?? 0;
                      final setsValue = type == 'workout'
                          ? int.tryParse(setsController.text) ?? 0
                          : 0;
                      final planData = PlanModel(
                        id: plan?.id ?? '',
                        userId: uid,
                        type: type,
                        title: titleController.text.isEmpty
                            ? 'Untitled ${type.capitalizeFirstLetter} Plan'
                            : titleController.text,
                        details: type == 'diet'
                            ? {
                                'meals': [
                                  {
                                    'food': nameController.text,
                                    'calories': numberValue,
                                  },
                                ],
                              }
                            : {
                                'exercises': [
                                  {
                                    'name': nameController.text,
                                    'reps': numberValue,
                                    'sets': setsValue,
                                  },
                                ],
                              },
                        assignedBy: FirebaseAuth.instance.currentUser!.uid,
                        createdAt: DateTime.now(),
                      );
                      final success = await controller.assignClientPlan(
                        uid,
                        planData,
                      );
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Success',
                          '${type.capitalizeFirstLetter} plan ${mode == 'add' ? 'assigned' : 'updated'}',
                          backgroundColor: AdminTheme.colors['primary'],
                          colorText: AdminTheme.colors['surface'],
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Failed to ${mode == 'add' ? 'assign' : 'update'} ${type.capitalizeFirstLetter} plan',
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['surface'],
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Invalid input: $e',
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
    );
  }
}
