import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme.dart';
import 'empty_placeholder.dart';

class WorkoutList extends StatelessWidget {
  final List exercises;
  const WorkoutList({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) return const EmptyPlaceholder(text: "No exercises found");

    return Column(
      children: exercises.map((exercise) {
        final instructions = exercise['instructions'] as List? ?? [];
        final name = exercise['name'] ?? '';
        final sets = exercise['sets']?.toString() ?? '0';
        final repsType = exercise['repsType'] ?? 'Reps';
        final reps = exercise['reps']?.toString() ?? '0';
        final description = exercise['description'] ?? '';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12.h),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              leading: Icon(Icons.fitness_center, color: AdminTheme.colors['primary']),
              title: Text(
                name,
                style: AdminTheme.textStyles['body']!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                _buildKeyValueRow("Sets", sets),
                _buildKeyValueRow(repsType, reps),

                if (description.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: AdminTheme.textStyles['body']!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: AdminTheme.textStyles['body'],
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],

                if (instructions.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Instructions",
                      style: AdminTheme.textStyles['body']!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: instructions.map((instr) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.chevron_right,
                                size: 18.sp, color: AdminTheme.colors['primary']),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                instr['text'] ?? '',
                                style: AdminTheme.textStyles['body'],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Simplified key-value row (label left, value right)
  Widget _buildKeyValueRow(String key, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              key,
              style: AdminTheme.textStyles['body']!.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AdminTheme.textStyles['body']!.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
