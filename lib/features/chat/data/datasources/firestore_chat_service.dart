import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../model/message_model.dart';

class FirestoreChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
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

  Future<String> createOrGetChat(String adminId, String participantId, String participantName) async {
    final chatId = _generateChatId(adminId, participantId);
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [adminId, participantId],
        'participantName': participantName,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
      });
    }
    return chatId;
  }

  String _generateChatId(String adminId, String participantId) {
    final ids = [adminId, participantId]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}