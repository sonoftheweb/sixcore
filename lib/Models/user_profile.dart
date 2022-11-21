class UserProfile {
  final String userId;
  final String name;
  final double height;
  final int weight;
  final int age;

  UserProfile({
    required this.userId,
    required this.name,
    required this.height,
    required this.weight,
    required this.age,
  });

  UserProfile.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId']! as String,
          name: json['name']! as String,
          height: json['height']! as double,
          weight: json['weight']! as int,
          age: json['age']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'name': name,
      'height': height,
      'weight': weight,
      'age': age,
    };
  }
}
