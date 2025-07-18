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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AdminTheme.colors['secondary'],
                  backgroundImage: client.profilePicture?.isNotEmpty == true
                      ? NetworkImage(client.profilePicture!)
                      : null,
                  child: client.profilePicture?.isEmpty != false
                      ? Text(
                          client.name.isNotEmpty ? client.name[0].toUpperCase() : '',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 16.w),
                Text(
                  client.name,
                  style: AdminTheme.textStyles['title']!.copyWith(
                    color: AdminTheme.colors['textPrimary'],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
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
            Text(
              'Gender: ${client.gender ?? 'Not set'}',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Age: ${client.age?.toString() ?? 'Not set'}',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Activity Level: ${client.activityLevel ?? 'Not set'}',
              style: AdminTheme.textStyles['body'],
            ),
          ],
        ),
      ),
    );
  }
}