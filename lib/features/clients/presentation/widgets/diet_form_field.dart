import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/form_validators.dart';

class DietFormFields extends GetView<PlanController> {
  const DietFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
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
                ...(meal['foods'] as List).asMap().entries.map((foodEntry) {
                  final foodIndex = foodEntry.key;
                  final food = foodEntry.value;
                  final foodNameController = TextEditingController(
                    text: food['name'],
                  );
                  final quantityController = TextEditingController(
                    text: food['quantity'],
                  );
                  final caloriesController = TextEditingController(
                    text: food['calories'],
                  );
                  foodNameController.addListener(() {
                    food['name'] = foodNameController.text;
                    controller.meals.refresh();
                  });
                  quantityController.addListener(() {
                    food['quantity'] = quantityController.text;
                    controller.meals.refresh();
                  });
                  caloriesController.addListener(() {
                    food['calories'] = caloriesController.text;
                    controller.meals.refresh();
                  });
                  return Column(
                    children: [
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: foodNameController,
                        labelText: 'Food Name (e.g., Dosa)',
                        validator: FormValidators.validatePlanDetails,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: quantityController,
                        labelText: 'Quantity (e.g., 100g)',
                        validator: FormValidators.validatePlanDetails,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: caloriesController,
                        labelText: 'Calories',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            FormValidators.validateNumber(value, 'Calories'),
                      ),
                      SizedBox(height: 8.h),
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
                }),
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
                  icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                  onPressed: () => controller.removeMeal(index),
                ),
              ],
            );
          }),
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
        ],
      ),
    );
  }
}
