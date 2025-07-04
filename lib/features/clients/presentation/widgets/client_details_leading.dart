import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/client_controller.dart';

class ClientDetailsLeading extends StatelessWidget {
  final ClientController controller;

  const ClientDetailsLeading({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(40.w, 40.h)),
          icon: Icon(
            Icons.arrow_back,
            color: AdminTheme.colors['textPrimary'],
            size: 20.w,
          ),
          onPressed: () => Get.back(),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: CircleAvatar(
            radius: 14.r,
            backgroundColor: AdminTheme.colors['primary']?.withOpacity(0.1),
            backgroundImage:
                controller.selectedClient.value?.profilePicture?.isNotEmpty ==
                    true
                ? NetworkImage(controller.selectedClient.value!.profilePicture!)
                : null,
            child:
                controller.selectedClient.value?.profilePicture?.isEmpty !=
                    false
                ? Text(
                    controller.selectedClient.value?.name.isNotEmpty == true
                        ? controller.selectedClient.value!.name[0]
                        : '',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['textPrimary'],
                      fontSize: 12.sp,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
