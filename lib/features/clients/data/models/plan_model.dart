import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String? id;
  final String title;
  final String type;
  final String userId;
  final String? assignedBy;
  final Map<String, dynamic> details;
  final bool isFavorite;
  final Timestamp createdAt;

  PlanModel({
    this.id,
    required this.title,
    required this.type,
    required this.userId,
    this.assignedBy,
    required this.details,
    required this.isFavorite,
    required this.createdAt,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] as String?,
      title: map['title'] as String? ?? 'Unnamed Plan',
      type: map['type'] as String,
      userId: map['userId'] as String,
      assignedBy: map['assignedBy'] as String?,
      details: Map<String, dynamic>.from(map['details'] ?? {}),
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'userId': userId,
      'assignedBy': assignedBy,
      'details': details,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
    };
  }
}
