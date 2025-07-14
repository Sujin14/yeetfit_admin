class ClientModel {
  String uid;
  final String name;
  final String email;
  final String? goal;
  final double? height;
  final double? currentWeight;
  final double? goalWeight;
  final String? gender;
  final int? age;
  final String? activityLevel;
  final String? profilePicture;

  ClientModel({
    required this.uid,
    required this.name,
    required this.email,
    this.goal,
    this.height,
    this.currentWeight,
    this.goalWeight,
    this.gender,
    this.age,
    this.activityLevel,
    this.profilePicture,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      goal: map['goal'],
      height: (map['height'] as num?)?.toDouble(),
      currentWeight: (map['currentWeight'] as num?)?.toDouble(),
      goalWeight: (map['goalWeight'] as num?)?.toDouble(),
      gender: map['gender'],
      age: map['age'],
      activityLevel: map['activityLevel'],
      profilePicture: map['profilePicture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'goal': goal,
      'height': height,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'gender': gender,
      'age': age,
      'activityLevel': activityLevel,
      'profilePicture': profilePicture,
    };
  }
}
