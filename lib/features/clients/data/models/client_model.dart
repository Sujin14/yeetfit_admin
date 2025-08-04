class ClientModel {
  final String uid;
  final String name;
  final String? email; // Made nullable to accommodate cases where email isn't provided
  final String? gender; // Made nullable for flexibility
  final int? age; // Made nullable for flexibility
  final String? goal; // Already nullable in second model
  final double? currentWeight; // Made nullable for flexibility
  final double? goalWeight; // Made nullable for flexibility
  final double? height; // Made nullable for flexibility
  final String? activityLevel; // Made nullable for flexibility
  final int? timeDurationWeeks; // Already nullable in first model
  final String? profilePicture; // From second model

  ClientModel({
    required this.uid,
    required this.name,
    this.email,
    this.gender,
    this.age,
    this.goal,
    this.currentWeight,
    this.goalWeight,
    this.height,
    this.activityLevel,
    this.timeDurationWeeks,
    this.profilePicture,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      gender: map['gender'],
      age: map['age'],
      goal: map['goal'],
      currentWeight: (map['currentWeight'] as num?)?.toDouble(),
      goalWeight: (map['goalWeight'] as num?)?.toDouble(),
      height: (map['height'] as num?)?.toDouble(),
      activityLevel: map['activityLevel'],
      timeDurationWeeks: map['timeDurationWeeks'],
      profilePicture: map['profilePicture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'goal': goal,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'height': height,
      'activityLevel': activityLevel,
      'timeDurationWeeks': timeDurationWeeks,
      'profilePicture': profilePicture,
    };
  }
}