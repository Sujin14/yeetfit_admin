import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';

class DietFormFields extends StatelessWidget {
  final String controllerTag;
  const DietFormFields({super.key, required this.controllerTag});

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
            labelText: 'Diet Plan Title',
            validator: FormValidators.validatePlanDetails,
          ),
          SizedBox(height: 16.h),
          Text(
            'Meals',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          GetBuilder<PlanController>(
            tag: controllerTag,
            builder: (controller) => Column(
              children: controller.meals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
                final mealControllers = meal['controllers'];
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
                            Expanded(
                              child: CustomTextField(
                                controller: mealControllers['name'],
                                labelText: 'Meal Name (e.g., Breakfast)',
                                validator: FormValidators.validatePlanDetails,
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
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Foods',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textPrimary'],
                          ),
                        ),
                        ...(meal['foods'] as List).asMap().entries.map((foodEntry) {
                          final foodIndex = foodEntry.key;
                          final food = foodEntry.value;
                          final f = food['controllers'];

                          return Card(
                            elevation: 1,
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: f['name'],
                                    labelText: 'Food Name (e.g., Dosa)',
                                    validator: FormValidators.validatePlanDetails,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          controller: f['quantity'],
                                          labelText: 'Quantity',
                                          validator: FormValidators.validatePlanDetails,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Unit',
                                            labelStyle: TextStyle(
                                              color: AdminTheme.colors['textSecondary'],
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          value: food['unit'] ?? 'g',
                                          items: ['g', 'ml', 'number'].map((unit) {
                                            return DropdownMenuItem(
                                              value: unit,
                                              child: Text(unit),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              controller.updateUnit(index, foodIndex, value);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextField(
                                    controller: f['calories'],
                                    labelText: 'Calories',
                                    keyboardType: TextInputType.number,
                                    validator: (value) => FormValidators.validateNumber(value, 'Calories'),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextField(
                                    controller: f['description'],
                                    labelText: 'Description (Optional)',
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 8.h),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: AdminTheme.colors['error'],
                                    ),
                                    onPressed: () => controller.removeFood(index, foodIndex),
                                  ),
                                ],
                              ),
                            ),
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
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 8.h),
          CustomButton(text: 'Add More Meal', onPressed: controller.addMeal),
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