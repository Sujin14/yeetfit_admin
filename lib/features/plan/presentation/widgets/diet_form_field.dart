import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/diet_plan_controller.dart.dart';
import 'meal_form.dart';

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
            labelText: 'Title*',
            validator: FormValidators.validatePlanTitle,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.title,
                color: AdminTheme.colors['textSecondary'],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Description',
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
          CustomTextField(
            controller: controller.totalCaloriesController,
            labelText: 'Total Calories*',
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
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                'Macronutrients*',
                style: AdminTheme.textStyles['title']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                ),
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.all(16.w),
              children: [
                CustomTextField(
                  controller: controller.proteinController,
                  labelText: 'Protein*',
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
                  controller: controller.carbsController,
                  labelText: 'Carbohydrates*',
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
                  controller: controller.fatsController,
                  labelText: 'Fats*',
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
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Meals',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          Obx(
            () => Column(
              children: controller.meals.entries.map((entry) {
                return MealForm(
                  mealName: entry.key,
                  meal: entry.value,
                  controllerTag: controllerTag,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Custom Meal',
            onPressed: controller.addMeal,
            icon: Icons.add,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'Cancel',
                onPressed: () => Get.back(),
                icon: Icons.cancel,
              ),
              CustomButton(
                text: controller.isEditMode.value ? 'Update Plan' : 'Save Plan',
                onPressed: controller.savePlan,
                icon: Icons.save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
