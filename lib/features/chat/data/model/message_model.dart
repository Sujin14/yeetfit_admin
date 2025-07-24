import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final List<String> participants;
  final String participantName;
  final String status; // sent, delivered, read
  final String? audioUrl;
  final bool isAudio;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.participants,
    required this.participantName,
    this.status = 'sent',
    this.audioUrl,
    this.isAudio = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      participants: List<String>.from(map['participants'] ?? []),
      participantName: map['participantName'] ?? 'Unknown',
      status: map['status'] ?? 'sent',
      audioUrl: map['audioUrl'],
      isAudio: map['audioUrl'] != null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'participants': participants,
      'participantName': participantName,
      'status': status,
      'audioUrl': audioUrl,
    };
  }
}