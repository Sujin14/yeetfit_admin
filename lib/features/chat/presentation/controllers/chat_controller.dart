import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../../domain/use_cases/create_or_get_chat.dart';
import '../../domain/use_cases/delete_chat.dart';
import '../../domain/use_cases/delete_message.dart';
import '../../domain/use_cases/get_chat_messages.dart';
import '../../domain/use_cases/get_message_status.dart';
import '../../domain/use_cases/get_user_profile.dart';
import '../../domain/use_cases/send_message.dart';
import '../../domain/use_cases/update_message_status.dart';
import '../../domain/use_cases/update_typing_status.dart';
import '../../domain/use_cases/get_typing_status.dart';

class ChatController extends GetxController {
  final GetChatMessages getChatMessages;
  final GetMessageStatus getMessageStatus;
  final GetUserProfile getUserProfile;
  final SendMessage sendMessage;
  final CreateOrGetChat createOrGetChat;
  final UpdateTypingStatus updateTypingStatus;
  final GetTypingStatus getTypingStatus;
  final UpdateMessageStatus updateMessageStatus;
  final DeleteChat deleteChat;
  final DeleteMessage deleteMessage;

  ChatController({
    required this.getChatMessages,
    required this.getMessageStatus,
    required this.getUserProfile,
    required this.sendMessage,
    required this.createOrGetChat,
    required this.updateTypingStatus,
    required this.getTypingStatus,
    required this.updateMessageStatus,
    required this.deleteChat,
    required this.deleteMessage,
  });

  final messages = <MessageModel>[].obs;
  final isLoadingMessages = true.obs;
  final messageController = TextEditingController();
  final messageText = ''.obs;
  final isTyping = false.obs;
  final participantTyping = false.obs;
  final participantName = ''.obs;
  final participantImage = ''.obs;
  String? _chatId;
  String? _participantId;

  @override
  void onInit() {
    super.onInit();
  }

  void setupChat(String participantId) {
    _participantId = participantId;
    final args = Get.arguments as Map<String, dynamic>;
    participantName.value = args['participantName'] as String;
    participantImage.value = args['participantImage'] as String? ?? '';
    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (adminId.isEmpty) {
      Get.snackbar('Error', 'User not authenticated',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
      return;
    }
    createOrGetChat(adminId, participantId, participantName.value).then((chatId) {
      _chatId = chatId;
      getChatMessages(chatId).listen((data) {
        messages.assignAll(data);
        isLoadingMessages.value = false;
        if (data.isEmpty) {
          Get.snackbar('Info', 'No messages yet. Start the conversation!',
              backgroundColor: AdminTheme.colors['primary'],
              colorText: AdminTheme.colors['onPrimary'],
              duration: const Duration(seconds: 3));
        }
        for (var message in data) {
          if (message.senderId != adminId && message.status != 'read') {
            updateMessageStatus(chatId, message.id, 'read');
          }
        }
      }, onError: (e) {
        isLoadingMessages.value = false;
        Get.snackbar('Error', 'Failed to load messages: $e',
            backgroundColor: AdminTheme.colors['error'],
            colorText: AdminTheme.colors['onError']);
      });
      getTypingStatus(chatId, participantId).listen((typing) {
        participantTyping.value = typing;
      }, onError: (e) {
        Get.snackbar('Error', 'Failed to load typing status: $e',
            backgroundColor: AdminTheme.colors['error'],
            colorText: AdminTheme.colors['onError']);
      });
      getUserProfile(participantId).listen((profile) {
        participantName.value = profile['name'] ?? participantName.value;
        participantImage.value = profile['profileImage'] ?? participantImage.value;
      }, onError: (e) {
        Get.snackbar('Error', 'Failed to load user profile: $e',
            backgroundColor: AdminTheme.colors['error'],
            colorText: AdminTheme.colors['onError']);
      });
    }).catchError((e) {
      isLoadingMessages.value = false;
      Get.snackbar('Error', 'Failed to setup chat: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    });
  }

  void updateMessage(String value) {
    messageText.value = value;
    updateTypingStatus(_chatId!, FirebaseAuth.instance.currentUser!.uid, value.isNotEmpty);
  }

  Future<void> sendMessages() async {
    if (messageText.value.trim().isEmpty || _chatId == null || _participantId == null) return;

    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: adminId,
      content: messageText.value.trim(),
      timestamp: DateTime.now(),
      participants: [adminId, _participantId!],
      participantName: participantName.value,
      status: 'sent',
    );

    await sendMessage(_chatId!, message);
    messageController.clear();
    messageText.value = '';
    updateTypingStatus(_chatId!, adminId, false);
  }

  Future<void> deleteChats() async {
    if (_chatId != null) {
      await deleteChat(_chatId!);
      Get.back();
    }
  }

  Future<void> deleteMessages(String messageId) async {
    if (_chatId != null) {
      await deleteMessage(_chatId!, messageId);
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}