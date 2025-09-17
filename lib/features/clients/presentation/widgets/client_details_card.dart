import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../data/models/client_model.dart';

class ClientDetailsCard extends StatelessWidget {
  final ClientModel client;

  const ClientDetailsCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.zero,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        color: AdminTheme.colors['surface'],
        child: Padding(
          padding: LayoutConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'client-avatar-${client.uid}',
                child: CircleAvatar(
                  radius: isWeb ? 60.0 : 80.r,
                  backgroundColor: AdminTheme.colors['secondary'],
                  backgroundImage: client.profilePicture?.isNotEmpty == true
                      ? NetworkImage(client.profilePicture!)
                      : null,
                  child: client.profilePicture?.isNotEmpty != true
                      ? Text(
                          client.name.isNotEmpty
                              ? client.name[0].toUpperCase()
                              : '',
                          style: AdminTheme.textStyles['title']!.copyWith(
                            color: AdminTheme.colors['onPrimary'],
                            fontSize: isWeb ? 24.0 : 30.sp,
                          ),
                        )
                      : null,
                ),
              ),

              SizedBox(height: LayoutConstants.itemSpacing * 2),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AdminTheme.colors['primary']!,
                      AdminTheme.colors['secondary']!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  client.goal ?? 'No Goal',
                  style: AdminTheme.textStyles['title']!.copyWith(
                    color: AdminTheme.colors['onPrimary'],
                    fontSize: isWeb ? 18.0 : 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: LayoutConstants.itemSpacing),

              _buildDetailRow(
                "Height",
                client.height?.toStringAsFixed(1) ?? "Not set",
                "cm",
              ),
              _buildDetailRow(
                "Current Weight",
                client.currentWeight?.toStringAsFixed(1) ?? "Not set",
                "kg",
              ),
              _buildDetailRow(
                "Goal Weight",
                client.goalWeight?.toStringAsFixed(1) ?? "Not set",
                "kg",
              ),
              _buildDetailRow("Gender", client.gender ?? "Not set"),
              _buildDetailRow("Age", client.age?.toString() ?? "Not set"),
              _buildDetailRow(
                "Activity Level",
                client.activityLevel ?? "Not set",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [String unit = ""]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AdminTheme.textStyles['body']!.copyWith(
              fontWeight: FontWeight.w600,
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
          Text(
            "$value ${unit.isNotEmpty ? unit : ''}",
            style: AdminTheme.textStyles['body']!.copyWith(
              fontWeight: FontWeight.bold,
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
        ],
      ),
    );
  }
}
