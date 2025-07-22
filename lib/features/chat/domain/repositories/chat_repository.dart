import '../../data/model/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Future<String> createOrGetChat(String adminId, String participantId, String participantName);
}