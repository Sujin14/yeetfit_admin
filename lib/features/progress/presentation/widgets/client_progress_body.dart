import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_progress_controller.dart';
import 'progress_card.dart';

class ClientProgressBody extends StatelessWidget {
  const ClientProgressBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProgressController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AdminTheme.colors['primary']),
        );
      }

      if (controller.error.value.isNotEmpty) {
        return CustomErrorWidget(
          message: controller.error.value,
          onRetry: () => controller.fetchProgressData(),
        );
      }

      if (controller.progressData.isEmpty) {
        return Center(
          child: Text(
            'No progress data found for ${DateFormat('yyyy-MM-dd').format(controller.selectedDate.value)}',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Text(
              'Progress for ${DateFormat('EEEE, MMMM dd, yyyy').format(controller.selectedDate.value)}',
              style: AdminTheme.textStyles['title'],
            ),
            SizedBox(height: 16.h),
            ProgressCard(
              title: 'Water Progress',
              dataKey: 'water',
              goalField: 'goalLiters',
              currentField: 'currentLiters',
              unit: 'L',
            ),
            SizedBox(height: 8.h),
            ProgressCard(
              title: 'Weight Progress',
              dataKey: 'weight',
              goalField: 'goalWeight',
              currentField: 'currentWeight',
              unit: 'kg',
            ),
            SizedBox(height: 8.h),
            ProgressCard(
              title: 'Steps Progress',
              dataKey: 'steps',
              goalField: 'goalSteps',
              currentField: 'currentSteps',
              unit: 'steps',
            ),
            SizedBox(height: 8.h),
            ProgressCard(
              title: 'Sleep Progress',
              dataKey: 'sleep',
              goalField: 'goalHours',
              currentField: 'currentHours',
              unit: 'hrs',
            ),
            SizedBox(height: 8.h),
            ProgressCard(
              title: 'Food Progress',
              dataKey: 'food/daily_goals',
              goalField: 'goalCalories',
              currentField: 'currentCalories',
              unit: 'kcal',
            ),
          ],
        ),
      );
    });
  }
}