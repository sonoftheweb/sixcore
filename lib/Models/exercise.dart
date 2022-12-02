class Exercise {
  final String image;
  final String name;
  final List areas;
  final List routineModes;
  final List routineSubModes;

  Exercise({
    required this.name,
    required this.areas,
    required this.image,
    required this.routineModes,
    required this.routineSubModes,
  });

  Exercise.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          image: json['image']! as String,
          areas: json['areas']! as List,
          routineModes: json['routineModes']! as List,
          routineSubModes: json['routineSubModes']! as List,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'image': image,
      'areas': areas,
      'routineModes': routineModes,
      'routineSubModes': routineSubModes,
    };
  }
}
