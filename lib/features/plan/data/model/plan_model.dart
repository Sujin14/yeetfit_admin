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
  final int totalCalories; // Total calories to eat (diet) or burn (workout)
  final Map<String, double> totalMacronutrients; // Total protein, carbs, fats for diet

  PlanModel({
    this.id,
    required this.title,
    required this.type,
    required this.userId,
    this.assignedBy,
    required this.details,
    required this.isFavorite,
    required this.createdAt,
    required this.totalCalories,
    this.totalMacronutrients = const {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
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
      totalCalories: map['totalCalories'] as int? ?? 0,
      totalMacronutrients: Map<String, double>.from(map['totalMacronutrients'] ?? {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0}),
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
      'totalCalories': totalCalories,
      'totalMacronutrients': totalMacronutrients,
    };
  }
}