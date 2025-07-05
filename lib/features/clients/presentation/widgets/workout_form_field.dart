import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/form_validators.dart';

class WorkoutFormFields extends GetView<PlanController> {
  const WorkoutFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.workoutTitleController,
            labelText: 'Workout Plan Title',
            validator: FormValidators.validatePlanDetails,
          ),
          SizedBox(height: 16.h),
          Text(
            'Exercises',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
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
                    if (value == null || value.isEmpty) return null; // Optional
                    if (!RegExp(
                      r'^https?://(www\.)?(youtube\.com|youtu\.be)/.+$',
                    ).hasMatch(value)) {
                      return 'Enter a valid YouTube URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),
                IconButton(
                  icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
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
      ),
    );
  }
}
