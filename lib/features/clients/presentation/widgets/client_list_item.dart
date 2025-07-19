import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/client_model.dart';

class ClientListItem extends StatelessWidget {
  final ClientModel client;

  const ClientListItem({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: AdminTheme.colors['primary']?.withOpacity(0.1),
          backgroundImage: client.profilePicture?.isNotEmpty == true
              ? NetworkImage(client.profilePicture!)
              : null,
          child: client.profilePicture?.isEmpty != false
              ? Text(
                  client.name.isNotEmpty ? client.name[0] : '',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textPrimary'],
                  ),
                )
              : null,
        ),
        title: Text(
          client.name,
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.w,
          color: AdminTheme.colors['textSecondary'],
        ),
        onTap: () async {
          if (client.uid.isEmpty) {
            print('ClientListItem: Cannot navigate, client UID is null or empty');
            Get.snackbar(
              'Error',
              'Cannot navigate to client details: Invalid client ID',
              backgroundColor: AdminTheme.colors['error'],
              colorText: AdminTheme.colors['surface'],
            );
            return;
          }
          print('ClientListItem: Navigating to /home/client-details with UID: ${client.uid}');
          try {
            await Get.toNamed(
              '/home/client-details',
              arguments: {'uid': client.uid},
            );
            print('ClientListItem: Navigation to /home/client-details completed');
          } catch (e) {
            print('ClientListItem: Navigation error - $e');
            Get.snackbar(
              'Error',
              'Navigation failed: $e',
              backgroundColor: AdminTheme.colors['error'],
              colorText: AdminTheme.colors['surface'],
            );
          }
        },
      ),
    );
  }
}