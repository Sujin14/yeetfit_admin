import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/preview_controller.dart';
import '../controllers/workout_plan_controller.dart';
import 'exercise_form.dart';

class WorkoutFormFields extends StatelessWidget {
  final String controllerTag;
  const WorkoutFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutPlanController>(tag: controllerTag);
    Get.put(PreviewController(controllerTag), tag: 'preview-$controllerTag');

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.titleController,
            labelText: 'Title*',
            validator: FormValidators.validatePlanTitle,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title, color: AdminTheme.colors['textSecondary']),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Description',
            maxLines: 3,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.description, color: AdminTheme.colors['textSecondary']),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: controller.totalCaloriesController,
            labelText: 'Total Calories*',
            keyboardType: TextInputType.number,
            validator: FormValidators.validateCalories,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.local_fire_department, color: AdminTheme.colors['textSecondary']),
              suffixText: 'cal',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 24.h),
          Obx(() {
            if (controller.exercises.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add exercises to save",
                    style: AdminTheme.textStyles['body']!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AdminTheme.colors['textPrimary'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: AdminTheme.colors['primary']),
                    onPressed: controller.addExercise,
                  )
                ],
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Exercises",
                      style: AdminTheme.textStyles['title']!.copyWith(
                        color: AdminTheme.colors['textPrimary'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: AdminTheme.colors['primary']),
                      onPressed: controller.addExercise,
                    ),
                  ],
                ),
                ...controller.exercises.asMap().entries.map((entry) {
                  return ExerciseForm(
                    exercise: entry.value,
                    index: entry.key,
                    controllerTag: controllerTag,
                  );
                }).toList(),
              ],
            );
          }),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'Cancel',
                onPressed: () => Get.back(),
                icon: Icons.cancel,
              ),
              CustomButton(
                text: controller.isEditMode.value ? 'Update Plan' : 'Save Plan',
                onPressed: controller.savePlan,
                icon: Icons.save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
