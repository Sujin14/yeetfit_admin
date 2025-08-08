import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final messageItems = <dynamic>[].obs; // Messages and date separators
  String? _chatId;
  String? _participantId;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void setupChat(String participantId) {
    _participantId = participantId;
    final args = Get.arguments as Map<String, dynamic>;
    participantName.value = args['participantName'] as String;
    participantImage.value = args['participantImage'] as String? ?? '';
    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (adminId.isEmpty) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['onError'],
      );
      return;
    }
    createOrGetChat(adminId, participantId, participantName.value)
        .then((chatId) {
          _chatId = chatId;
          getChatMessages(chatId).listen(
            (data) {
              messages.assignAll(data);
              _updateMessageItems(data);
              isLoadingMessages.value = false;
              if (data.isEmpty) {
                Get.snackbar(
                  'Info',
                  'No messages yet. Start the conversation!',
                  backgroundColor: AdminTheme.colors['primary'],
                  colorText: AdminTheme.colors['onPrimary'],
                  duration: const Duration(seconds: 3),
                );
              }
              for (var message in data) {
                if (message.senderId != adminId && message.status != 'read') {
                  updateMessageStatus(chatId, message.id, 'read');
                }
              }
            },
            onError: (e) {
              isLoadingMessages.value = false;
              Get.snackbar(
                'Error',
                'Failed to load messages: $e',
                backgroundColor: AdminTheme.colors['error'],
                colorText: AdminTheme.colors['onError'],
              );
            },
          );
          getTypingStatus(chatId, participantId).listen(
            (typing) {
              participantTyping.value = typing;
            },
            onError: (e) {
              Get.snackbar(
                'Error',
                'Failed to load typing status: $e',
                backgroundColor: AdminTheme.colors['error'],
                colorText: AdminTheme.colors['onError'],
              );
            },
          );
          getUserProfile(participantId).listen(
            (profile) {
              participantName.value = profile['name'] ?? participantName.value;
              participantImage.value =
                  profile['profileImage'] ?? participantImage.value;
            },
            onError: (e) {
              Get.snackbar(
                'Error',
                'Failed to load user profile: $e',
                backgroundColor: AdminTheme.colors['error'],
                colorText: AdminTheme.colors['onError'],
              );
            },
          );
        })
        .catchError((e) {
          isLoadingMessages.value = false;
          Get.snackbar(
            'Error',
            'Failed to setup chat: $e',
            backgroundColor: AdminTheme.colors['error'],
            colorText: AdminTheme.colors['onError'],
          );
        });
  }

  void updateMessage(String value) {
    messageText.value = value;
    updateTypingStatus(
      _chatId!,
      FirebaseAuth.instance.currentUser!.uid,
      value.isNotEmpty,
    );
  }

  Future<void> sendMessages() async {
    if (messageText.value.trim().isEmpty ||
        _chatId == null ||
        _participantId == null)
      return;

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

  void showMessageOptions(BuildContext context, MessageModel message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Message Options',
          style: AdminTheme.textStyles['titleMedium'],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Copy', style: AdminTheme.textStyles['bodyMedium']),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Get.back();
                Get.snackbar(
                  'Success',
                  'Message copied to clipboard',
                  backgroundColor: AdminTheme.colors['primary'],
                  colorText: AdminTheme.colors['onPrimary'],
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
                deleteMessages(message.id);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteChatDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Chat', style: AdminTheme.textStyles['titleMedium']),
        content: Text(
          'Are you sure you want to delete the entire chat?',
          style: AdminTheme.textStyles['bodyMedium'],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AdminTheme.textStyles['bodyMedium']),
          ),
          TextButton(
            onPressed: () async {
              await deleteChats();
              Get.back();
            },
            child: Text(
              'Delete',
              style: AdminTheme.textStyles['bodyMedium']?.copyWith(
                color: AdminTheme.colors['error'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMessageItems(List<MessageModel> messages) {
    final items = <dynamic>[];
    if (messages.isEmpty) {
      messageItems.assignAll(items);
      return;
    }
    final reversedMessages = messages.reversed.toList();
    DateTime? lastDate;

    for (var message in reversedMessages) {
      final currentDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (lastDate == null || currentDate != lastDate) {
        items.add(_formatDate(message.timestamp));
        lastDate = currentDate;
      }
      items.add(message);
    }
    messageItems.assignAll(items);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MMM/yyyy').format(date);
    }
  }
}
