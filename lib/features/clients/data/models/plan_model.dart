import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final Map<String, dynamic> details;
  final String assignedBy;
  final DateTime createdAt;

  PlanModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.details,
    required this.assignedBy,
    required this.createdAt,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    final details = Map<String, dynamic>.from(map['details'] ?? {});
    if (details['meals'] != null && details['meals'] is List) {
      details['meals'] = (details['meals'] as List).map((meal) {
        final mealMap = Map<String, dynamic>.from(meal);
        if (mealMap['calories'] is String) {
          mealMap['calories'] = int.tryParse(mealMap['calories']) ?? 0;
        }
        return mealMap;
      }).toList();
    }
    if (details['exercises'] != null && details['exercises'] is List) {
      details['exercises'] = (details['exercises'] as List).map((exercise) {
        final exerciseMap = Map<String, dynamic>.from(exercise);
        if (exerciseMap['reps'] is String) {
          exerciseMap['reps'] = int.tryParse(exerciseMap['reps']) ?? 0;
        }
        if (exerciseMap['sets'] is String) {
          exerciseMap['sets'] = int.tryParse(exerciseMap['sets']) ?? 0;
        }
        return exerciseMap;
      }).toList();
    }

    return PlanModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Untitled Plan',
      details: details,
      assignedBy: map['assignedBy']?.toString() ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'details': details,
      'assignedBy': assignedBy,
      'createdAt': FieldValue.serverTimestamp(),
    }..removeWhere((key, value) => value == null);
  }
}
