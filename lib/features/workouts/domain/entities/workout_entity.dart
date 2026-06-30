import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final int durationMins;
  final int? caloriesBurned;
  final DateTime loggedAt;
  final String? notes;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.durationMins,
    required this.caloriesBurned,
    required this.loggedAt,
    this.notes,
  });

  WorkoutEntity copyWith({
    String? id,
    String? userId,
    String? title,
    int? durationMins,
    int? caloriesBurned,
    DateTime? loggedAt,
    String? notes,
  }) {
    return WorkoutEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      durationMins: durationMins ?? this.durationMins,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    durationMins,
    caloriesBurned,
    loggedAt,
    notes,
  ];
}
