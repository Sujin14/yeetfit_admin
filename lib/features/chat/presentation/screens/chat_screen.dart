import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_header.dart';
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
              child: ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return MessageBubble(message: msg, controller: controller);
                },
              ),
            ),
            MessageInput(controller: controller),
          ],
        );
      }),
    );
  }
}
