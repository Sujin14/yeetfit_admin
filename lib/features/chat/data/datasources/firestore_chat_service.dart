import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../model/message_model.dart';

class FirestoreChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreChatService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.error(Exception('User not authenticated'));
    }
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<MessageModel> getMessageStatus(String chatId, String messageId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .snapshots()
        .map((doc) => MessageModel.fromMap(doc.data()!, doc.id));
  }

  Stream<Map<String, dynamic>> getUserProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data() ?? {'name': 'Unknown', 'profileImage': ''});
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.content,
        'lastMessageTime': Timestamp.fromDate(message.timestamp),
        'participants': message.participants,
        'participantName': message.participantName,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'typing_$userId': isTyping,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update typing status: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Stream<bool> getTypingStatus(String chatId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) => doc.data()?['typing_$userId'] ?? false);
  }

  Future<void> updateMessageStatus(String chatId, String messageId, String status) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'status': status});
    } catch (e) {
      Get.snackbar('Error', 'Failed to update message status: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      final messages = await _firestore.collection('chats').doc(chatId).collection('messages').get();
      for (var doc in messages.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete chat: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete message: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
    }
  }

  Future<String> createOrGetChat(String adminId, String participantId, String participantName) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid != adminId) {
        throw Exception('User is not authenticated or adminId does not match current user');
      }
      if (adminId.isEmpty || participantId.isEmpty || adminId == participantId) {
        throw Exception('Invalid admin or participant ID');
      }
      final chatId = _generateChatId(adminId, participantId);
      final chatRef = _firestore.collection('chats').doc(chatId);

      await chatRef.set({
        'participants': [adminId, participantId],
        'participantName': participantName,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'typing_$adminId': false,
        'typing_$participantId': false,
      }, SetOptions(merge: true));

      return chatId;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create or get chat: $e',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['onError']);
      rethrow;
    }
  }

  String _generateChatId(String adminId, String participantId) {
    final ids = [adminId, participantId]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}