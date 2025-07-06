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
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.titleController,
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
          GetBuilder<PlanController>(
            builder: (controller) => Column(
              children: controller.exercises.asMap().entries.map((entry) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercise ${index + 1}',
                          style: AdminTheme.textStyles['title']!.copyWith(
                            color: AdminTheme.colors['textPrimary'],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: AdminTheme.colors['error'],
                          ),
                          onPressed: () => controller.removeExercise(index),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Exercise Name',
                      validator: FormValidators.validatePlanDetails,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Reps/Time',
                              labelStyle: TextStyle(
                                color: AdminTheme.colors['textSecondary'],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            value: exercise['repsType'] ?? 'reps',
                            items: ['reps', 'time'].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.capitalizeFirstLetter),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.updateRepsType(index, value);
                                repsController.clear();
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomTextField(
                            controller: repsController,
                            labelText: exercise['repsType'] == 'reps'
                                ? 'Reps'
                                : 'Time',
                            keyboardType: exercise['repsType'] == 'reps'
                                ? TextInputType.number
                                : TextInputType.text,
                            validator: (value) =>
                                FormValidators.validatePlanDetails(value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Sets',
                              labelStyle: TextStyle(
                                color: AdminTheme.colors['textSecondary'],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            value: exercise['sets']?.isNotEmpty ?? false
                                ? exercise['sets']
                                : null,
                            hint: Text(
                              'Select sets',
                              style: TextStyle(
                                color: AdminTheme.colors['textSecondary'],
                              ),
                            ),
                            items: List.generate(10, (i) => (i + 1).toString())
                                .map((set) {
                                  return DropdownMenuItem(
                                    value: set,
                                    child: Text(set),
                                  );
                                })
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                exercise['sets'] = value;
                                setsController.text = value;
                                controller.exercises.refresh();
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomTextField(
                            controller: setsController,
                            labelText: 'Custom Sets',
                            keyboardType: TextInputType.number,
                            validator: (value) => null, // Optional field
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
                      labelText: 'YouTube Video URL (Optional)',
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (!RegExp(
                          r'^https?://(www\.)?(youtube\.com|youtu\.be)/.+$',
                        ).hasMatch(value)) {
                          return 'Enter a valid YouTube URL';
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
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
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: controller.savePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.colors['primary'],
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Save Plan',
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
