import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/diet_plan_controller.dart.dart';

class FoodForm extends StatelessWidget {
  final String mealName;
  final Map<String, dynamic> food;
  final int foodIndex;
  final String controllerTag;

  const FoodForm({
    super.key,
    required this.mealName,
    required this.food,
    required this.foodIndex,
    required this.controllerTag,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DietPlanController>(tag: controllerTag);
    final f = food['controllers'];

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(
          color: AdminTheme.colors['textSecondary']!,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            CustomTextField(
              controller: f['name'],
              labelText: 'Food Name (e.g., Dosa)',
              validator: (value) => FormValidators.validateName(value, 'food'),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.food_bank,
                  color: AdminTheme.colors['textSecondary'],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: f['quantity'],
                    labelText: 'Quantity',
                    keyboardType: TextInputType.number,
                    validator: FormValidators.validateQuantity,
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
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateUnit(mealName, foodIndex, value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: f['calories'],
              labelText: 'Calories',
              keyboardType: TextInputType.number,
              validator: FormValidators.validateCalories,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.local_fire_department,
                  color: AdminTheme.colors['textSecondary'],
                ),
                suffixText: 'cal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: f['protein'],
              labelText: 'Protein (Optional)',
              keyboardType: TextInputType.number,
              validator: FormValidators.validateMacronutrient,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.food_bank,
                  color: AdminTheme.colors['textSecondary'],
                ),
                suffixText: 'g',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: f['carbs'],
              labelText: 'Carbohydrates (Optional)',
              keyboardType: TextInputType.number,
              validator: FormValidators.validateMacronutrient,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.food_bank,
                  color: AdminTheme.colors['textSecondary'],
                ),
                suffixText: 'g',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: f['fats'],
              labelText: 'Fats (Optional)',
              keyboardType: TextInputType.number,
              validator: FormValidators.validateMacronutrient,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.food_bank,
                  color: AdminTheme.colors['textSecondary'],
                ),
                suffixText: 'g',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: f['description'],
              labelText: 'Description (Optional)',
              maxLines: 3,
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
            IconButton(
              icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
              onPressed: () => controller.removeFood(mealName, foodIndex),
            ),
          ],
        ),
      ),
    );
  }
}
