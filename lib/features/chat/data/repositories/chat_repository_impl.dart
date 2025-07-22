import '../../domain/repositories/chat_repository.dart';
import '../datasources/firestore_chat_service.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatService service;

  ChatRepositoryImpl(this.service);

  @override
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return service.getChatMessages(chatId);
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) {
    return service.sendMessage(chatId, message);
  }

  @override
  Future<String> createOrGetChat(String adminId, String participantId, String participantName) {
    return service.createOrGetChat(adminId, participantId, participantName);
  }
}