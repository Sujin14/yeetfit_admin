import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/chat_controller.dart';

class MessageInput extends StatelessWidget {
  final ChatController controller;

  const MessageInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AdminTheme.colors['background'],
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.messageController,
              labelText: 'Type a message...',
              onChanged: controller.updateMessage,
              decoration: InputDecoration(
                fillColor: AdminTheme.colors['inputBackground'],
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(Icons.send_rounded, color: AdminTheme.colors['primary'],size: 45,),
            onPressed: controller.sendMessages,
          ),
        ],
      ),
    );
  }
}
