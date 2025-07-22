import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/message_model.dart';
import '../../domain/use_cases/create_or_get_chat.dart';
import '../../domain/use_cases/get_chat_messages.dart';
import '../../domain/use_cases/send_message.dart';

class ChatController extends GetxController {
  final GetChatMessages getChatMessages;
  final SendMessage sendMessages;
  final CreateOrGetChat createOrGetChat;

  ChatController({
    required this.getChatMessages,
    required this.sendMessages,
    required this.createOrGetChat,
  });

  final messages = <MessageModel>[].obs;
  final isLoadingMessages = true.obs;
  final messageController = TextEditingController();
  final messageText = ''.obs;
  String? _chatId;
  String? _participantId;
  String? _participantName;

  void setupChat(String participantId) {
    _participantId = participantId;
    _participantName = Get.arguments['participantName'] as String;
    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    createOrGetChat(adminId, participantId, _participantName!).then((chatId) {
      _chatId = chatId;
      getChatMessages(chatId).listen((data) {
        messages.assignAll(data);
        isLoadingMessages.value = false;
      });
    });
  }

  void updateMessage(String value) {
    messageText.value = value;
  }

  void sendMessage() async {
    if (messageText.value.trim().isEmpty || _chatId == null || _participantId == null) return;

    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: adminId,
      content: messageText.value.trim(),
      timestamp: DateTime.now(),
      participants: [adminId, _participantId!],
      participantName: _participantName!,
    );

    await sendMessages(_chatId!, message);
    messageController.clear();
    messageText.value = '';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}