import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final DateTime date;
  final int steps;
  final double waterIntake;
  final double calorieIntake;

  ProgressModel({
    required this.date,
    required this.steps,
    required this.waterIntake,
    required this.calorieIntake,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      steps: map['steps'] ?? 0,
      waterIntake: (map['waterIntake'] ?? 0.0).toDouble(),
      calorieIntake: (map['calorieIntake'] ?? 0.0).toDouble(),
    );
  }
}
