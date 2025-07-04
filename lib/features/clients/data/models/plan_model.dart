import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String userId;
  final String type;
  final Map<String, dynamic> details;
  final String assignedBy;
  final DateTime createdAt;

  PlanModel({
    required this.userId,
    required this.type,
    required this.details,
    required this.assignedBy,
    required this.createdAt,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      details: Map<String, dynamic>.from(map['details'] ?? {}),
      assignedBy: map['assignedBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'details': details,
      'assignedBy': assignedBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
