import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/diet_plan_controller.dart.dart';

class DietFormFields extends StatelessWidget {
  final String controllerTag;
  const DietFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DietPlanController>(tag: controllerTag);

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.titleController,
            labelText: 'Diet Plan Title',
            validator: FormValidators.validatePlanTitle,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title, color: AdminTheme.colors['textSecondary']),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Description (Optional)',
            maxLines: 3,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.description, color: AdminTheme.colors['textSecondary']),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          ExpansionTile(
            title: Text(
              'Nutrition Goals',
              style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.all(16.w),
            initiallyExpanded: true,
            children: [
              CustomTextField(
                controller: controller.totalCaloriesController,
                labelText: 'Total Calories to Eat',
                keyboardType: TextInputType.number,
                validator: FormValidators.validateCalories,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.local_fire_department, color: AdminTheme.colors['textSecondary']),
                  suffixText: 'cal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Meals',
            style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
          ),
          GetBuilder<DietPlanController>(
            tag: controllerTag,
            builder: (controller) => Column(
              children: controller.meals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
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
                            mealControllers['name'].text.isEmpty
                                ? 'Meal ${index + 1}'
                                : mealControllers['name'].text,
                            style: AdminTheme.textStyles['body']!.copyWith(
                              color: AdminTheme.colors['textPrimary'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                          onPressed: () => controller.removeMeal(index),
                        ),
                      ],
                    ),
                    tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    childrenPadding: EdgeInsets.all(16.w),
                    children: [
                      CustomTextField(
                        controller: mealControllers['name'],
                        labelText: 'Meal Name (e.g., Breakfast)',
                        validator: (value) => FormValidators.validateName(value, 'meal'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.restaurant, color: AdminTheme.colors['textSecondary']),
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
                        final f = food['controllers'];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(color: AdminTheme.colors['textSecondary']!, width: 0.5),
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
                                    prefixIcon: Icon(Icons.food_bank, color: AdminTheme.colors['textSecondary']),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
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
                                          prefixIcon: Icon(Icons.numbers, color: AdminTheme.colors['textSecondary']),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Unit',
                                          labelStyle: TextStyle(color: AdminTheme.colors['textSecondary']),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                        ),
                                        value: food['unit'] ?? 'g',
                                        items: ['g', 'ml', 'number'].map((unit) {
                                          return DropdownMenuItem(value: unit, child: Text(unit));
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
                                SizedBox(height: 16.h),
                                CustomTextField(
                                  controller: f['calories'],
                                  labelText: 'Calories',
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
                                  controller: f['protein'],
                                  labelText: 'Protein',
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
                                  controller: f['carbs'],
                                  labelText: 'Carbohydrates',
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
                                  controller: f['fats'],
                                  labelText: 'Fats',
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
                                  controller: f['description'],
                                  labelText: 'Description (Optional)',
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.description, color: AdminTheme.colors['textSecondary']),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                IconButton(
                                  icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
                                  onPressed: () => controller.removeFood(index, foodIndex),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'Add Food',
                        onPressed: () => controller.addFood(index),
                        icon: Icons.add,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Add More Meal',
            onPressed: controller.addMeal,
            icon: Icons.add,
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
              text: 'Save Plan',
              isLoading: controller.isLoading.value,
              onPressed: controller.savePlan,
              icon: Icons.save,
            ),
          ),
        ],
      ),
    );
  }
}