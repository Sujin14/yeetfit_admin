import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/date_utils.dart';
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
  Widget build(context) {
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
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: false,
                      itemCount: _calculateItemCount(controller.messages),
                      itemBuilder: (context, index) {
                        final item = _getItemAtIndex(
                          controller.messages,
                          index,
                        );
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
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
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

  // Calculate total item count (messages + date separators)
  int _calculateItemCount(RxList<MessageModel> messages) {
    if (messages.isEmpty) return 0;
    int count = messages.length;
    DateTime? lastDate;
    for (var message in messages.reversed) {
      final currentDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (lastDate == null || currentDate != lastDate) {
        count++; // Add a date separator
        lastDate = currentDate;
      }
    }
    return count;
  }

  // Get item at index (either a MessageModel or a date string)
  dynamic _getItemAtIndex(RxList<MessageModel> messages, int index) {
    if (messages.isEmpty) return null;
    final reversedMessages = messages.reversed.toList();
    int currentIndex = 0;
    DateTime? lastDate;

    for (int i = 0; i < reversedMessages.length; i++) {
      final message = reversedMessages[i];
      final currentDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || currentDate != lastDate) {
        if (currentIndex == index) {
          return getFormattedDate(message.timestamp);
        }
        currentIndex++;
        lastDate = currentDate;
      }

      if (currentIndex == index) {
        return message;
      }
      currentIndex++;
    }
    return null;
  }
}
