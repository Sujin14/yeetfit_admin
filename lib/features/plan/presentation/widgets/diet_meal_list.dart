import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme.dart';
import 'empty_placeholder.dart';

class DietMealList extends StatelessWidget {
  final Map<String, dynamic> meals;
  const DietMealList({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return const EmptyPlaceholder(text: "No meals found");

    // Define preferred order
    final order = ["breakfast", "morning snack", "lunch", "evening snack", "dinner"];

    // Sort meals according to order, keeping others at the end
    final sortedEntries = meals.entries.toList()
      ..sort((a, b) {
        final ai = order.indexOf(a.key.toLowerCase());
        final bi = order.indexOf(b.key.toLowerCase());
        if (ai == -1 && bi == -1) return a.key.compareTo(b.key); // alphabetic for unknowns
        if (ai == -1) return 1; // unknowns go last
        if (bi == -1) return -1;
        return ai.compareTo(bi);
      });

    return Column(
      children: sortedEntries.map((entry) {
        final mealName = entry.key;
        final meal = entry.value as Map<String, dynamic>;
        final foods = meal['foods'] as List? ?? [];
        final description = meal['description'] ?? '';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12.h),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              title: Text(
                mealName,
                style: AdminTheme.textStyles['body']!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              leading: Icon(Icons.restaurant_menu, color: AdminTheme.colors['primary']),
              childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                _buildKeyValueRow("Total Calories", "${meal['calories'] ?? 0}", context),
                if (description.isNotEmpty)
                  _buildKeyValueRow("Description", description, context),
                SizedBox(height: 12.h),

                // Foods Section
                ...foods.map((food) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildKeyValueRow("Food", food['name'] ?? '', context,
                              isBold: true),
                          if ((food['description'] ?? '').isNotEmpty)
                            _buildKeyValueRow(
                                "Description", food['description'], context),
                          _buildKeyValueRow(
                            "Quantity",
                            "${food['quantity'] ?? ''} ${food['unit'] ?? ''}",
                            context,
                          ),
                          _buildKeyValueRow(
                            "Calories",
                            "${food['calories'] ?? 0}",
                            context,
                          ),
                          Divider(height: 12.h, color: Colors.grey.shade300),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Helper widget to build key-value pair rows (label left, value right)
  Widget _buildKeyValueRow(String key, String value, BuildContext context,
      {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              key,
              style: AdminTheme.textStyles['body']!.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: AdminTheme.textStyles['body']!.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
