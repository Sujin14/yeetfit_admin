import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../../domain/use_cases/upload_audio.dart';

class ChatController extends GetxController {
  final GetChatMessages getChatMessages;
  final GetMessageStatus getMessageStatus;
  final GetUserProfile getUserProfile;
  final SendMessage sendMessage;
  final CreateOrGetChat createOrGetChat;
  final UploadAudio uploadAudio;
  final UpdateTypingStatus updateTypingStatus;
  final GetTypingStatus getTypingStatus;
  final UpdateMessageStatus updateMessageStatus;
  final DeleteChat deleteChat;
  final DeleteMessage deleteMessage;
  final isPlaying = false.obs;
  final currentAudioUrl = ''.obs;
  final audioDuration = Duration.zero.obs;

  Stream<Duration> get positionStream => _player.positionStream;

  ChatController({
    required this.getChatMessages,
    required this.getMessageStatus,
    required this.getUserProfile,
    required this.sendMessage,
    required this.createOrGetChat,
    required this.uploadAudio,
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
  final isRecording = false.obs;
  final participantTyping = false.obs;
  final participantName = ''.obs;
  final participantImage = ''.obs;
  String? _chatId;
  String? _participantId;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  @override
  void onInit() async {
    super.onInit();
    await _requestPermissions();
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _requestPermissions() async {
    if (await Permission.microphone.request().isDenied) {
      Get.snackbar('Permission Denied', 'Microphone access is required to record audio',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
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

  Future<void> sendAudioMessage(File audioFile) async {
    if (_chatId == null || _participantId == null) return;

    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final audioUrl = await uploadAudio(audioFile, _chatId!, messageId);
    final message = MessageModel(
      id: messageId,
      senderId: adminId,
      content: 'Audio message',
      timestamp: DateTime.now(),
      participants: [adminId, _participantId!],
      participantName: participantName.value,
      status: 'sent',
      audioUrl: audioUrl,
      isAudio: true,
    );

    await sendMessage(_chatId!, message);
  }

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      isRecording.value = true;
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
    } else {
      Get.snackbar('Permission Denied', 'Microphone access is required to record audio',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stopRecorder();
    isRecording.value = false;
    if (path != null) {
      await sendAudioMessage(File(path));
    }
  }

  Future<void> playAudio(String url) async {
    if (currentAudioUrl.value != url) {
      await _player.setUrl(url);
      audioDuration.value = _player.duration ?? Duration.zero;
      currentAudioUrl.value = url;
    }
    isPlaying.value = true;
    await _player.play();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
      }
    });
  }

  Future<void> stopAudio() async {
    await _player.stop();
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
    _recorder.closeRecorder();
    _player.dispose();
    super.onClose();
  }
}