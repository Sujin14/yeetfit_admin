import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/diet_plan_controller.dart.dart';
import 'food_form.dart';

class MealForm extends StatelessWidget {
  final String mealName;
  final Map<String, dynamic> meal;
  final String controllerTag;

  const MealForm({
    super.key,
    required this.mealName,
    required this.meal,
    required this.controllerTag,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DietPlanController>(tag: controllerTag);
    final mealControllers = meal['controllers'];

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AdminTheme.colors['textSecondary']!, width: 0.5),
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                mealName,
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'].contains(mealName))
              IconButton(
                icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                onPressed: () => controller.removeMeal(mealName),
              ),
          ],
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        childrenPadding: EdgeInsets.all(16.w),
        children: [
          CustomTextField(
            controller: controller.mealCalorieControllers[mealName],
            labelText: 'Calorie Goal',
            keyboardType: TextInputType.number,
            validator: FormValidators.validateCalories,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.local_fire_department, color: AdminTheme.colors['textSecondary']),
              suffixText: 'cal',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: mealControllers['protein'],
            labelText: 'Protein (Optional)',
            keyboardType: TextInputType.number,
            validator: FormValidators.validateMacronutrient,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.food_bank, color: AdminTheme.colors['textSecondary']),
              suffixText: 'g',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: mealControllers['carbs'],
            labelText: 'Carbohydrates (Optional)',
            keyboardType: TextInputType.number,
            validator: FormValidators.validateMacronutrient,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.food_bank, color: AdminTheme.colors['textSecondary']),
              suffixText: 'g',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: mealControllers['fats'],
            labelText: 'Fats (Optional)',
            keyboardType: TextInputType.number,
            validator: FormValidators.validateMacronutrient,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.food_bank, color: AdminTheme.colors['textSecondary']),
              suffixText: 'g',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Foods',
            style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textPrimary']),
          ),
          ...(meal['foods'] as List).asMap().entries.map((foodEntry) {
            final foodIndex = foodEntry.key;
            final food = foodEntry.value;
            return FoodForm(
              mealName: mealName,
              food: food,
              foodIndex: foodIndex,
              controllerTag: controllerTag,
            );
          }).toList(),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Add Food',
            onPressed: () => controller.addFood(mealName),
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}