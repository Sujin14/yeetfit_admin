import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit_admin/features/chat/data/model/message_model.dart';
import '../../../../core/theme/theme.dart';
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
              onLongPress: () {
                _showMessageOptions(context);
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AdminTheme.colors['inputBackground']
                        : AdminTheme.colors['surfaceVariant'],
                    borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(12.r) : Radius.zero,
                      topRight: isMe ? Radius.circular(12.r): Radius.zero,
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.zero,
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

  void _showMessageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Message Options',
            style: AdminTheme.textStyles['titleMedium'],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Copy',
                  style: AdminTheme.textStyles['bodyMedium'],
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Message copied to clipboard"),
                      backgroundColor: AdminTheme.colors['primary'],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Delete',
                  style: AdminTheme.textStyles['bodyMedium']?.copyWith(
                    color: AdminTheme.colors['error'],
                  ),
                ),
                onTap: () {
                  controller.deleteMessages(message.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
