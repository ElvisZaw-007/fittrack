import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';

class WorkoutModel {
  final String id;
  final String userId;
  final String title;
  final int durationMins;
  final int? caloriesBurned;
  final DateTime loggedAt;
  final String? notes;

  const WorkoutModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.durationMins,
    this.caloriesBurned,
    required this.loggedAt,
    this.notes,
  });
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      durationMins: json['durationMins'],
      caloriesBurned: json['calories_burned'],
      loggedAt: json['loggedAt'],
      notes: json['notes'],
    );
  }
  WorkoutEntity toEntity() {
    return WorkoutEntity(
      id: id,
      userId: userId,
      title: title,
      durationMins: durationMins,
      caloriesBurned: caloriesBurned,
      loggedAt: loggedAt,
      notes: notes,
    );
  }

  factory WorkoutModel.fromEntity(WorkoutEntity entity) {
    return WorkoutModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      durationMins: entity.durationMins,
      caloriesBurned: entity.caloriesBurned,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'title': title,
      'duration_mins': durationMins,
      'calories_burned': caloriesBurned,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
    };
  }
}
