import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String? id;
  final String title;
  final int durationMins;
  final int? caloriesBurned;
  final DateTime loggedAt;
  final String? notes;

  const WorkoutEntity({
    this.id,
    required this.title,
    required this.durationMins,
    this.caloriesBurned,
    required this.loggedAt,
    this.notes,
  });

  WorkoutEntity copyWith({
    String? id,
    String? title,
    int? durationMins,
    int? caloriesBurned,
    DateTime? loggedAt,
    String? notes,
  }) {
    return WorkoutEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMins: durationMins ?? this.durationMins,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    durationMins,
    caloriesBurned,
    loggedAt,
    notes,
  ];
}
