import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../../data/models/plan_model.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/form_validators.dart';

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
    // Initialize form fields from plan if in edit mode
    if (mode == 'edit' && plan != null) {
      controller.dietTitleController.text = type == 'diet' ? plan!.title : '';
      controller.workoutTitleController.text = type == 'workout'
          ? plan!.title
          : '';
      if (type == 'diet' && plan!.details['meals'] != null) {
        controller.meals.assignAll(plan!.details['meals']);
      } else if (type == 'workout' && plan!.details['exercises'] != null) {
        controller.exercises.assignAll(plan!.details['exercises']);
      }
    } else if (controller.meals.isEmpty && controller.exercises.isEmpty) {
      // Initialize with one empty meal/exercise for add mode
      if (type == 'diet') {
        controller.meals.add({
          'name': '',
          'foods': [
            {'quantity': '', 'calories': ''},
          ],
        });
      } else {
        controller.exercises.add({
          'name': '',
          'reps': '',
          'sets': '',
          'description': '',
          'instructions': '',
          'videoUrl': '',
        });
      }
    }

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan Details',
                style: AdminTheme.textStyles['title']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: type == 'diet'
                    ? controller.dietTitleController
                    : controller.workoutTitleController,
                labelText: 'Plan Title',
                validator: FormValidators.validatePlanDetails,
              ),
              SizedBox(height: 16.h),
              Text(
                type == 'diet' ? 'Meals' : 'Exercises',
                style: AdminTheme.textStyles['title']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                ),
              ),
              if (type == 'diet') ...[
                ...controller.meals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final meal = entry.value;
                  final mealNameController = TextEditingController(
                    text: meal['name'],
                  );
                  mealNameController.addListener(() {
                    meal['name'] = mealNameController.text;
                    controller.meals.refresh();
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: mealNameController,
                        labelText: 'Meal Name (e.g., Breakfast)',
                        validator: FormValidators.validatePlanDetails,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Foods',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textPrimary'],
                        ),
                      ),
                      ...(meal['foods'] as List).asMap().entries.map((
                        foodEntry,
                      ) {
                        final foodIndex = foodEntry.key;
                        final food = foodEntry.value;
                        final quantityController = TextEditingController(
                          text: food['quantity'],
                        );
                        final caloriesController = TextEditingController(
                          text: food['calories'],
                        );
                        quantityController.addListener(() {
                          food['quantity'] = quantityController.text;
                          controller.meals.refresh();
                        });
                        caloriesController.addListener(() {
                          food['calories'] = caloriesController.text;
                          controller.meals.refresh();
                        });
                        return Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: quantityController,
                                labelText: 'Quantity (e.g., 100g)',
                                validator: FormValidators.validatePlanDetails,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CustomTextField(
                                controller: caloriesController,
                                labelText: 'Calories',
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    FormValidators.validateNumber(
                                      value,
                                      'Calories',
                                    ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AdminTheme.colors['error'],
                              ),
                              onPressed: () =>
                                  controller.removeFood(index, foodIndex),
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 8.h),
                      TextButton(
                        onPressed: () => controller.addFood(index),
                        child: Text(
                          'Add Food',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['primary'],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AdminTheme.colors['error'],
                        ),
                        onPressed: () => controller.removeMeal(index),
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: controller.addMeal,
                  child: Text(
                    'Add More Meal',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['primary'],
                    ),
                  ),
                ),
              ] else ...[
                ...controller.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  final nameController = TextEditingController(
                    text: exercise['name'],
                  );
                  final repsController = TextEditingController(
                    text: exercise['reps'],
                  );
                  final setsController = TextEditingController(
                    text: exercise['sets'],
                  );
                  final descriptionController = TextEditingController(
                    text: exercise['description'],
                  );
                  final instructionsController = TextEditingController(
                    text: exercise['instructions'],
                  );
                  final videoUrlController = TextEditingController(
                    text: exercise['videoUrl'],
                  );
                  nameController.addListener(() {
                    exercise['name'] = nameController.text;
                    controller.exercises.refresh();
                  });
                  repsController.addListener(() {
                    exercise['reps'] = repsController.text;
                    controller.exercises.refresh();
                  });
                  setsController.addListener(() {
                    exercise['sets'] = setsController.text;
                    controller.exercises.refresh();
                  });
                  descriptionController.addListener(() {
                    exercise['description'] = descriptionController.text;
                    controller.exercises.refresh();
                  });
                  instructionsController.addListener(() {
                    exercise['instructions'] = instructionsController.text;
                    controller.exercises.refresh();
                  });
                  videoUrlController.addListener(() {
                    exercise['videoUrl'] = videoUrlController.text;
                    controller.exercises.refresh();
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: nameController,
                        labelText: 'Exercise Name',
                        validator: FormValidators.validatePlanDetails,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: repsController,
                              labelText: 'Reps',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  FormValidators.validateNumber(value, 'Reps'),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextField(
                              controller: setsController,
                              labelText: 'Sets',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  FormValidators.validateNumber(value, 'Sets'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: descriptionController,
                        labelText: 'Description',
                        maxLines: 3,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: instructionsController,
                        labelText: 'Instructions',
                        maxLines: 3,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: videoUrlController,
                        labelText: 'YouTube Video URL',
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return null; // Optional
                          if (!RegExp(
                            r'^https?://(www\.)?(youtube\.com|youtu\.be)/.+$',
                          ).hasMatch(value)) {
                            return 'Enter a valid YouTube URL';
                          }
                          return null;
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AdminTheme.colors['error'],
                        ),
                        onPressed: () => controller.removeExercise(index),
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: controller.addExercise,
                  child: Text(
                    'Add More Exercise',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['primary'],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              CustomButton(
                text: mode == 'add'
                    ? 'Assign ${type.capitalizeFirstLetter} Plan'
                    : 'Update ${type.capitalizeFirstLetter} Plan',
                isLoading: controller.isLoading.value,
                onPressed: () async {
                  if (controller.formKey.currentState!.validate()) {
                    final success = await controller.savePlan();
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
                        controller.error.value,
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

extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
