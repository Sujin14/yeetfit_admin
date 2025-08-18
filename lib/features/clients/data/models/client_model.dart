class ClientModel {
  final String uid;
  final String name;
  final String? email;
  final String? gender;
  final int? age;
  final String? goal;
  final double? currentWeight;
  final double? goalWeight;
  final double? height;
  final String? activityLevel;
  final int? timeDurationWeeks;
  final String? profilePicture;

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
