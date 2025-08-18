import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routes/app_routes.dart';
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
        leading: Hero(
          tag: 'client-avatar-${client.uid}',
          child: Material(
            color: AdminTheme.colors['transperent'],
            child: CircleAvatar(
              radius: 24.r,
              backgroundColor: AdminTheme.colors['primary']?.withOpacity(0.1),
              child: client.profilePicture?.isNotEmpty == true
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: client.profilePicture!,
                        width: 48.r,
                        height: 48.r,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AdminTheme.colors['accent']!,
                          highlightColor: AdminTheme.colors['surface']!,
                          child: Container(
                            width: 48.r,
                            height: 48.r,
                            color: AdminTheme.colors['onPrimary'],
                          ),
                        ),
                        errorWidget: (context, url, error) => Text(
                          client.name.isNotEmpty
                              ? client.name[0].toUpperCase()
                              : '',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textPrimary'],
                          ),
                        ),
                      ),
                    )
                  : Text(
                      client.name.isNotEmpty
                          ? client.name[0].toUpperCase()
                          : '',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['textPrimary'],
                      ),
                    ),
            ),
          ),
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
        onTap: () {
          if (client.uid.isEmpty) {
            Get.snackbar(
              'Error',
              'Cannot navigate to client details: Invalid client ID',
              backgroundColor: AdminTheme.colors['error'],
              colorText: AdminTheme.colors['surface'],
            );
            return;
          }
          AppRoutes.debounceNavigate(
            '/home/client-details',
            arguments: {
              'uid': client.uid,
              'name': client.name,
              'profilePicture': client.profilePicture ?? '',
            },
          );
        },
      ),
    );
  }
}
