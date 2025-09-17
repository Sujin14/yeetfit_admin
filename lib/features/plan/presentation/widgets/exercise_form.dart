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
import 'instruction_form.dart';

class ExerciseForm extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final int index;
  final String controllerTag;

  const ExerciseForm({
    super.key,
    required this.exercise,
    required this.index,
    required this.controllerTag,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutPlanController>(tag: controllerTag);
    final previewController = Get.find<PreviewController>(
      tag: 'preview-$controllerTag',
    );
    final exCtrl = exercise['controllers'];

    return GetBuilder<PreviewController>(
      tag: 'preview-$controllerTag',
      id: index.toString(),
      builder: (previewCtrl) {
        final showPreview = index < previewCtrl.previewStates.length
            ? previewCtrl.previewStates[index]
            : false;
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: AdminTheme.colors['textSecondary']!,
              width: 0.5,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exCtrl['name']!.text.isEmpty
                          ? 'Exercise ${index + 1}'
                          : exCtrl['name']!.text,
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['textPrimary'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                    onPressed: () => controller.removeExercise(index),
                  ),
                ],
              ),
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              childrenPadding: EdgeInsets.all(16.w),
              children: [
                CustomTextField(
                  controller: exCtrl['name']!,
                  labelText: 'Exercise Name',
                  validator: (value) =>
                      FormValidators.validateName(value, 'exercise'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.fitness_center,
                      color: AdminTheme.colors['textSecondary'],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: exercise['repsType'],
                  items: const [
                    DropdownMenuItem(value: 'reps', child: Text('Reps')),
                    DropdownMenuItem(
                      value: 'duration',
                      child: Text('Duration (min)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateRepsType(index, value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Reps Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                exercise['repsType'] == 'reps'
                    ? CustomTextField(
                        controller: exCtrl['reps']!,
                        labelText: 'Reps',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            FormValidators.validateReps(value, 'reps'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.repeat,
                            color: AdminTheme.colors['textSecondary'],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      )
                    : CustomTextField(
                        controller: exCtrl['reps']!,
                        labelText: 'Duration',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            FormValidators.validateReps(value, 'duration'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.timer,
                            color: AdminTheme.colors['textSecondary'],
                          ),
                          suffixText: 'min',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                SizedBox(height: 16.h),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: exCtrl['sets']!,
                      labelText: 'Sets',
                      keyboardType: TextInputType.number,
                      validator: FormValidators.validateSets,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: AdminTheme.colors['textSecondary'],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (value) => controller.updateSets(index, value),
                      itemBuilder: (_) => List.generate(10, (i) {
                        final value = (i + 1).toString();
                        return PopupMenuItem(value: value, child: Text(value));
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: exCtrl['description']!,
                  labelText: 'Description (Optional)',
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: AdminTheme.colors['textSecondary'],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                /// Instructions Section
                Row(
                  children: [
                    Text(
                      "Instructions",
                      style: AdminTheme.textStyles['body']!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.colors['textPrimary'],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle,
                          color: AdminTheme.colors['primary']),
                      onPressed: () => controller.addInstruction(index),
                    ),
                  ],
                ),
                ...(exercise['instructions'] as List).asMap().entries.map((entry) {
                  final instrIndex = entry.key;
                  final instr = entry.value;
                  return InstructionForm(
                    exerciseIndex: index,
                    instruction: instr,
                    instructionIndex: instrIndex,
                    controllerTag: controllerTag,
                  );
                }).toList(),

                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: exCtrl['videoUrl']!,
                        labelText: 'Video URL (Optional)',
                        validator: FormValidators.validateYouTubeUrl,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.video_library,
                            color: AdminTheme.colors['textSecondary'],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomButton(
                      text: showPreview ? 'Hide Preview' : 'Preview',
                      onPressed: () => previewController.togglePreview(index),
                      icon:
                          showPreview ? Icons.visibility_off : Icons.visibility,
                    ),
                  ],
                ),
                if (showPreview &&
                    exCtrl['videoUrl']!.text.trim().isNotEmpty &&
                    FormValidators.validateYouTubeUrl(exCtrl['videoUrl']!.text) ==
                        null) ...[
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: YoutubePlayer(
                      controller: YoutubePlayerController.fromVideoId(
                        videoId: YoutubePlayerController.convertUrlToId(
                          exCtrl['videoUrl']!.text.trim(),
                        )!,
                        autoPlay: false,
                        params: const YoutubePlayerParams(
                          showFullscreenButton: true,
                        ),
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
  }
}
