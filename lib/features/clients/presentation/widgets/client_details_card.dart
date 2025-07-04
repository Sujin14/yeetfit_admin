import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../../data/models/client_model.dart';

class ClientDetailsCard extends StatelessWidget {
  final ClientModel client;

  const ClientDetailsCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Details', style: AdminTheme.textStyles['title']),
            SizedBox(height: 8.h),
            Text(
              'Email: ${client.email}',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Goal: ${client.goal ?? 'Not set'}',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Height: ${client.height?.toStringAsFixed(1) ?? 'Not set'} cm',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Current Weight: ${client.currentWeight?.toStringAsFixed(1) ?? 'Not set'} kg',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Goal Weight: ${client.goalWeight?.toStringAsFixed(1) ?? 'Not set'} kg',
              style: AdminTheme.textStyles['body'],
            ),
          ],
        ),
      ),
    );
  }
}
