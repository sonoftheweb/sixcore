class Workout {
  final String name;
  final String createdBy;
  final String assignedTo;
  final String workoutAreas;
  final String workoutSettings;

  Workout({
    required this.name,
    required this.createdBy,
    required this.assignedTo,
    required this.workoutAreas,
    required this.workoutSettings,
  });

  Workout.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          createdBy: json['createdBy']! as String,
          assignedTo: json['assignedTo']! as String,
          workoutAreas: json['workoutAreas']! as String,
          workoutSettings: json['workoutSettings']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'workoutAreas': workoutAreas,
      'workoutSettings': workoutSettings,
    };
  }
}
