import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/chat_controller.dart';

class ChatHeader extends StatelessWidget {
  final ChatController controller;

  const ChatHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        color: AdminTheme.colors['background'],
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AdminTheme.colors['primary']),
              onPressed: () => Get.back(),
            ),
            Obx(() => CircleAvatar(
                  radius: 25.r,
                  backgroundImage: CachedNetworkImageProvider(
                    controller.participantImage.value.isNotEmpty
                        ? controller.participantImage.value
                        : 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                  ),
                )),
            SizedBox(width: 12.w),
            Obx(() => Text(
                  controller.participantName.value,
                  style: AdminTheme.textStyles['heading']?.copyWith(
                    color: AdminTheme.colors['onSurface'],
                  ),
                )),
            const Spacer(),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AdminTheme.colors['primary']),
              onSelected: (value) {
                if (value == 'delete') {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Delete Chat', style: AdminTheme.textStyles['titleMedium']),
                      content: Text('Are you sure you want to delete the entire chat?', style: AdminTheme.textStyles['bodyMedium']),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel', style: AdminTheme.textStyles['bodyMedium']),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await controller.deleteChats();
                            } catch (e) {
                              Get.snackbar('Error', 'Failed to delete chat: $e',
                                  backgroundColor: AdminTheme.colors['error'],
                                  colorText: AdminTheme.colors['onError']);
                            }
                          },
                          child: Text(
                            'Delete',
                            style: AdminTheme.textStyles['bodyMedium']?.copyWith(
                              color: AdminTheme.colors['error'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Chat', style: AdminTheme.textStyles['bodyMedium']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}