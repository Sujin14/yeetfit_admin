import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/form_validators.dart';
import '../../presentation/controllers/plan_controller.dart';

class WorkoutFormFields extends StatelessWidget {
  final String controllerTag;
  const WorkoutFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanController>(tag: controllerTag);

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
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Plan Description (Optional)',
            maxLines: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            'Exercises',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          GetBuilder<PlanController>(
            tag: controllerTag,
            builder: (_) => Column(
              children: controller.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final exercise = entry.value;
                final exCtrl =
                    exercise['controllers']
                        as Map<String, TextEditingController>;

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exercise ${index + 1}',
                              style: AdminTheme.textStyles['body'],
                            ),
                            IconButton(
                              onPressed: () => controller.removeExercise(index),
                              icon: Icon(
                                Icons.delete,
                                color: AdminTheme.colors['error'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: exCtrl['name']!,
                          labelText: 'Exercise Name',
                          validator: FormValidators.validatePlanDetails,
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          value: exercise['repsType'],
                          items: const [
                            DropdownMenuItem(
                              value: 'reps',
                              child: Text('Reps'),
                            ),
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
                        SizedBox(height: 8.h),
                        exercise['repsType'] == 'reps'
                            ? CustomTextField(
                                controller: exCtrl['reps']!,
                                labelText: 'Reps',
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    FormValidators.validateNumber(
                                      value,
                                      'Reps',
                                    ),
                              )
                            : CustomTextField(
                                controller: exCtrl['reps']!,
                                labelText: 'Duration (min)',
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    FormValidators.validateNumber(value, ''),
                              ),
                        SizedBox(height: 8.h),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            CustomTextField(
                              controller: exCtrl['sets']!,
                              labelText: 'Sets',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  FormValidators.validateNumber(value, 'Sets'),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.arrow_drop_down),
                              onSelected: (value) {
                                exCtrl['sets']!.text = value;
                              },
                              itemBuilder: (_) => List.generate(10, (i) {
                                final value = (i + 1).toString();
                                return PopupMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
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
                        CustomTextField(
                          controller: exCtrl['instructions']!,
                          labelText: 'Instructions (Optional)',
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: exCtrl['videoUrl']!,
                          labelText: 'Video URL (Optional)',
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 8.h),
          CustomButton(
            text: 'Add More Exercise',
            onPressed: controller.addExercise,
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.bottomRight,
            child: Obx(
              () => CustomButton(
                text: 'Save Plan',
                isLoading: controller.isLoading.value,
                onPressed: controller.savePlan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
