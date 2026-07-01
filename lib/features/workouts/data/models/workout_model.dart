import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';

class WorkoutModel {
  final String id;
  final String title;
  final int durationMins;
  final int? caloriesBurned;
  final DateTime loggedAt;
  final String? notes;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.durationMins,
    this.caloriesBurned,
    required this.loggedAt,
    this.notes,
  });
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      title: json['title'] as String,
      durationMins: json['duration_mins'] as int,
      caloriesBurned: json['calories_burned'] as int?,
      loggedAt: DateTime.parse(json['logged_at'] as String),
      notes: json['notes'] as String?,
    );
  }
  WorkoutEntity toEntity() {
    return WorkoutEntity(
      id: id,
      title: title,
      durationMins: durationMins,
      caloriesBurned: caloriesBurned,
      loggedAt: loggedAt,
      notes: notes,
    );
  }

  factory WorkoutModel.fromEntity(WorkoutEntity entity) {
    return WorkoutModel(
      id: entity.id ?? '',
      title: entity.title,
      durationMins: entity.durationMins,
      caloriesBurned: entity.caloriesBurned,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toInsertJson({required String userId}) {
    return {
      'user_id': userId,
      'title': title,
      'duration_mins': durationMins,
      'calories_burned': caloriesBurned,
      'logged_at': loggedAt.toIso8601String().split('T').first,
      'notes': notes,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'duration_mins': durationMins,
      'calories_burned': caloriesBurned,
      'logged_at': loggedAt.toIso8601String().split('T').first,
      'notes': notes,
    };
  }
}
