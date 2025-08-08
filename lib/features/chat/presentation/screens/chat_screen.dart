import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_header.dart';
import '../widgets/date_seperator.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/home/client-details/chat';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final args = Get.arguments as Map<String, dynamic>;
    final participantId = args['participantId'] as String;

    controller.setupChat(participantId);

    return Scaffold(
      backgroundColor: AdminTheme.colors['background'],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(controller: controller),
      ),
      body: Obx(() {
        if (controller.isLoadingMessages.value) {
          return shimmerLoading();
        }
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: false,
                      itemCount: controller.messageItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.messageItems[index];
                        if (item is String) {
                          return DateSeparator(dateText: item);
                        } else if (item is MessageModel) {
                          return MessageBubble(
                            message: item,
                            controller: controller,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  if (controller.participantTyping.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Typing...',
                          style: AdminTheme.textStyles['bodySmall']?.copyWith(
                            color: AdminTheme.colors['onSurfaceVariant'],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            MessageInput(controller: controller),
          ],
        );
      }),
    );
  }
}