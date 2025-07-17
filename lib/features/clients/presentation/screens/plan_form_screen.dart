import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/plan_controller.dart';

// Displays the form for creating or editing diet/workout plans
class PlanFormScreen extends StatelessWidget {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final tag = 'plan-${args['uid']}-${args['type']}';
    final controller = Get.find<PlanController>(tag: tag);

    return Scaffold(
      // AppBar with dynamic title based on edit/add mode
      appBar: AppBar(
        title: Text(
          controller.isEditMode.value ? 'Edit ${controller.planType.value.capitalizeFirst} Plan' : 'Add ${controller.planType.value.capitalizeFirst} Plan',
          style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
        ),
        backgroundColor: AdminTheme.colors['surface'],
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdminTheme.colors['textPrimary']),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AdminTheme.colors['primary']));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h), // Standardized padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan Details',
                style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
              ),
              SizedBox(height: 8.h),
              // Input for plan title
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                ),
              ),
              SizedBox(height: 16.h),
              // Input for plan description
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
              // Displays meal or exercise section based on plan type
              if (controller.planType.value == 'diet')
                _buildMealSection(controller)
              else
                _buildExerciseSection(controller),
              SizedBox(height: 32.h),
              // Save button to submit the plan
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => controller.savePlan(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.colors['primary'],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    controller.isEditMode.value ? 'Update Plan' : 'Save Plan',
                    style: AdminTheme.textStyles['button']!.copyWith(color: AdminTheme.colors['surface']),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Builds the meal input section for diet plans
  Widget _buildMealSection(PlanController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meals', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary'])),
        SizedBox(height: 8.h),
        ...controller.meals.map((meal) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  TextField(
                    controller: meal['controllers']['name'],
                    decoration: InputDecoration(
                      labelText: 'Meal Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(meal['foods'].length, (i) {
                    final food = meal['foods'][i];
                    return Column(
                      children: [
                        TextField(
                          controller: food['controllers']['name'],
                          decoration: InputDecoration(
                            labelText: 'Food Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: food['controllers']['quantity'],
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: food['controllers']['calories'],
                          decoration: InputDecoration(
                            labelText: 'Calories',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: food['controllers']['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                          ),
                        ),
                        Divider(color: AdminTheme.colors['textSecondary']!.withOpacity(0.2)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // Builds the exercise input section for workout plans
  Widget _buildExerciseSection(PlanController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exercises', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary'])),
        SizedBox(height: 8.h),
        ...controller.exercises.map((exercise) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  TextField(
                    controller: exercise['controllers']['name'],
                    decoration: InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: exercise['controllers']['reps'],
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: exercise['controllers']['sets'],
                    decoration: InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: exercise['controllers']['description'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: exercise['controllers']['videoUrl'],
                    decoration: InputDecoration(
                      labelText: 'Video URL',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}