import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/home/client-details/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final args = Get.arguments as Map<String, dynamic>;
    final participantId = args['participantId'] as String;
    final participantName = args['participantName'] as String;

    controller.setupChat(participantId);

    return Scaffold(
      appBar: CustomAppBar(
        title: participantName,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMessages.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSentByAdmin = message.senderId == FirebaseAuth.instance.currentUser?.uid;
                  return Align(
                    alignment: isSentByAdmin ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      constraints: BoxConstraints(maxWidth: 0.7.sw),
                      decoration: BoxDecoration(
                        color: isSentByAdmin
                            ? AdminTheme.colors['primary']
                            : AdminTheme.colors['surfaceVariant'],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        message.content,
                        style: AdminTheme.textStyles['bodyMedium']?.copyWith(
                          color: isSentByAdmin
                              ? AdminTheme.colors['onPrimary']
                              : AdminTheme.colors['onSurface'],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AdminTheme.colors['surface'],
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.messageController,
              labelText: 'Type a message...',
              onChanged: controller.updateMessage,
            ),
          ),
          SizedBox(width: 8.w),
          CustomButton(
            text: 'Send',
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}