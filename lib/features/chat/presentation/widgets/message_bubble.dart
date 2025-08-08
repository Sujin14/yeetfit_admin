import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () => controller.showMessageOptions(context, message),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AdminTheme.colors['inputBackground']
                        : AdminTheme.colors['signupGradientEnd']!.withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(12.r) : Radius.zero,
                      topRight: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: isMe ? Radius.zero : Radius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    message.content,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: AdminTheme.textStyles['bodyMedium']?.copyWith(
                      color: isMe
                          ? AdminTheme.colors['surface']
                          : AdminTheme.colors['onSurface'],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: AdminTheme.textStyles['bodySmall']?.copyWith(
                    color: AdminTheme.colors['onSurfaceVariant'],
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  _buildMessageStatusIcon(message.status),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icon(Icons.check, size: 16.sp, color: AdminTheme.colors['onSurfaceVariant']);
      case 'delivered':
        return Icon(Icons.done_all, size: 16.sp, color: AdminTheme.colors['onSurfaceVariant']);
      case 'read':
        return Icon(Icons.done_all, size: 16.sp, color: AdminTheme.colors['primary']);
      default:
        return const SizedBox.shrink();
    }
  }
}