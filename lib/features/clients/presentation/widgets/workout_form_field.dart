import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/form_validators.dart';
import '../controllers/plan_controller.dart';

// Controller to manage preview visibility for each exercise
class PreviewController extends GetxController {
  final String tag;
  final previewStates = <bool>[].obs;

  PreviewController(this.tag);

  void initialize(int exerciseCount) {
    previewStates.assignAll(List.filled(exerciseCount, false));
  }

  void togglePreview(int index) {
    if (index < previewStates.length) {
      previewStates[index] = !previewStates[index];
      update([index.toString()]);
    }
  }
}

// Displays the form fields for creating/editing a workout plan
class WorkoutFormFields extends StatelessWidget {
  final String controllerTag;
  const WorkoutFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanController>(tag: controllerTag);
    final previewController = Get.put(PreviewController(controllerTag), tag: 'preview-$controllerTag');

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input for workout plan title
          CustomTextField(
            controller: controller.titleController,
            labelText: 'Workout Plan Title',
            validator: FormValidators.validatePlanTitle,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Plan Description (Optional)',
            maxLines: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            'Exercises',
            style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
          ),
          // Builds dynamic exercise input fields
          GetBuilder<PlanController>(
            tag: controllerTag,
            builder: (_) {
              // Initialize preview states based on exercise count
              previewController.initialize(controller.exercises.length);
              return Column(
                children: controller.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  final exCtrl = exercise['controllers'] as Map<String, TextEditingController>;

                  return GetBuilder<PreviewController>(
                    tag: 'preview-$controllerTag',
                    id: index.toString(),
                    builder: (previewCtrl) {
                      final showPreview = index < previewCtrl.previewStates.length ? previewCtrl.previewStates[index] : false;

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Exercise ${index + 1}', style: AdminTheme.textStyles['body']),
                                  // Delete button for exercise
                                  IconButton(
                                    onPressed: () => controller.removeExercise(index),
                                    icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                controller: exCtrl['name']!,
                                labelText: 'Exercise Name',
                                validator: (value) => FormValidators.validateName(value, 'exercise'),
                              ),
                              SizedBox(height: 8.h),
                              // Dropdown for selecting reps type
                              DropdownButtonFormField<String>(
                                value: exercise['repsType'],
                                items: const [
                                  DropdownMenuItem(value: 'reps', child: Text('Reps')),
                                  DropdownMenuItem(value: 'duration', child: Text('Duration (min)')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateRepsType(index, value);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Reps Type',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              exercise['repsType'] == 'reps'
                                  ? CustomTextField(
                                      controller: exCtrl['reps']!,
                                      labelText: 'Reps',
                                      keyboardType: TextInputType.number,
                                      validator: (value) => FormValidators.validateReps(value, 'reps'),
                                    )
                                  : CustomTextField(
                                      controller: exCtrl['reps']!,
                                      labelText: 'Duration (min)',
                                      keyboardType: TextInputType.number,
                                      validator: (value) => FormValidators.validateReps(value, 'duration'),
                                    ),
                              SizedBox(height: 8.h),
                              // Input for sets with a dropdown for quick selection
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  CustomTextField(
                                    controller: exCtrl['sets']!,
                                    labelText: 'Sets',
                                    keyboardType: TextInputType.number,
                                    validator: FormValidators.validateSets,
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    onSelected: (value) {
                                      exCtrl['sets']!.text = value;
                                    },
                                    itemBuilder: (_) => List.generate(10, (i) {
                                      final value = (i + 1).toString();
                                      return PopupMenuItem(value: value, child: Text(value));
                                    }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                controller: exCtrl['description']!,
                                labelText: 'Description (Optional)',
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Instructions',
                                style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textPrimary']),
                              ),
                              // Dynamic instruction input fields
                              ...(exercise['instructions'] as List).asMap().entries.map((instrEntry) {
                                final instrIndex = instrEntry.key;
                                final instr = instrEntry.value;
                                return Column(
                                  children: [
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            controller: instr['controller'],
                                            labelText: 'Instruction Step ${instrIndex + 1}',
                                            validator: FormValidators.validateInstruction,
                                          ),
                                        ),
                                        // Delete button for instruction
                                        IconButton(
                                          icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                                          onPressed: () => controller.removeInstruction(index, instrIndex),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(height: 8.h),
                              // Button to add more instructions
                              TextButton(
                                onPressed: () => controller.addInstruction(index),
                                child: Text(
                                  'Add Instruction',
                                  style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['primary']),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Input for YouTube URL with preview button
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: exCtrl['videoUrl']!,
                                      labelText: 'Video URL (Optional)',
                                      validator: FormValidators.validateYouTubeUrl,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomButton(
                                    text: showPreview ? 'Hide Preview' : 'Preview',
                                    onPressed: () {
                                      // Validate URL before showing preview
                                      final urlError = FormValidators.validateYouTubeUrl(exCtrl['videoUrl']!.text);
                                      if (urlError == null) {
                                        previewController.togglePreview(index);
                                      } else {
                                        // Trigger validation to show error below field
                                        controller.formKey.currentState?.validate();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (showPreview && exCtrl['videoUrl']!.text.trim().isNotEmpty && FormValidators.validateYouTubeUrl(exCtrl['videoUrl']!.text) == null) ...[
                                SizedBox(height: 8.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 200.h,
                                  child: YoutubePlayer(
                                    controller: YoutubePlayerController.fromVideoId(
                                      videoId: YoutubePlayerController.convertUrlToId(exCtrl['videoUrl']!.text.trim())!,
                                      autoPlay: false,
                                      params: const YoutubePlayerParams(showFullscreenButton: true),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 8.h),
          // Button to add more exercises
          CustomButton(
            text: 'Add More Exercise',
            onPressed: controller.addExercise,
          ),
          SizedBox(height: 16.h),
          // Save button for the workout plan
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
              text: 'Save Plan',
              isLoading: controller.isLoading.value,
              onPressed: controller.savePlan,
            ),
          ),
        ],
      ),
    );
  }
}