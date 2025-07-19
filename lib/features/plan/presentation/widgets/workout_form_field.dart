import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/preview_controller.dart';
import '../controllers/workout_plan_controller.dart';


class WorkoutFormFields extends StatelessWidget {
  final String controllerTag;
  const WorkoutFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutPlanController>(tag: controllerTag);
    final previewController = Get.put(PreviewController(controllerTag), tag: 'preview-$controllerTag');

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          GetBuilder<WorkoutPlanController>(
            tag: controllerTag,
            builder: (_) {
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
                              TextButton(
                                onPressed: () => controller.addInstruction(index),
                                child: Text(
                                  'Add Instruction',
                                  style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['primary']),
                                ),
                              ),
                              SizedBox(height: 8.h),
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
                                      final urlError = FormValidators.validateYouTubeUrl(exCtrl['videoUrl']!.text);
                                      if (urlError == null) {
                                        previewController.togglePreview(index);
                                      } else {
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
          CustomButton(
            text: 'Add More Exercise',
            onPressed: controller.addExercise,
          ),
          SizedBox(height: 16.h),
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