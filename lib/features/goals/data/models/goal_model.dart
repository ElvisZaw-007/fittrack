// lib/features/goals/data/models/goal_model.dart

import '../../domain/entities/goal.dart';

class GoalModel {
  final String? id;
  final String goalType;
  final double startWeight;
  final double targetWeight;
  final String startDate;
  final String targetDate;
  final String status;

  const GoalModel({
    required this.id,
    required this.goalType,
    required this.startWeight,
    required this.targetWeight,
    required this.startDate,
    required this.targetDate,
    required this.status,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
    id: json['id'] as String?,
    goalType: json['goal_type'] as String,
    startWeight: (json['start_weight'] as num).toDouble(),
    targetWeight: (json['target_weight'] as num).toDouble(),
    startDate: json['start_date'] as String,
    targetDate: json['target_date'] as String,
    status: json['status'] as String,
  );

  factory GoalModel.fromEntity(Goal goal) {
    return GoalModel(
      id: goal.id,
      goalType: goal.goalType.dbValue,
      startWeight: goal.startWeight,
      targetWeight: goal.targetWeight,
      startDate: goal.startDate.toIso8601String().substring(0, 10),
      targetDate: goal.targetDate.toIso8601String().substring(0, 10),
      status: goal.status.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_type': goalType,
      'start_weight': startWeight,
      'target_weight': targetWeight,
      'start_date': startDate,
      'target_date': targetDate,
      'status': status,
    };
  }

  Goal toEntity() => Goal(
    id: id,
    goalType: GoalTypeX.fromDb(goalType),
    startWeight: startWeight,
    targetWeight: targetWeight,
    startDate: DateTime.parse(startDate),
    targetDate: DateTime.parse(targetDate),
    status: GoalStatus.values.byName(status),
  );
}

/// Builds the insert payload for a new goal.
/// `id` is omitted — the database generates it via `default gen_random_uuid()`.
/// `user_id` comes from the authenticated session, not the entity.
Map<String, dynamic> goalToInsertJson(Goal goal, {required String userId}) => {
  'user_id': userId,
  'goal_type': goal.goalType.dbValue,
  'start_weight': goal.startWeight,
  'target_weight': goal.targetWeight,
  'start_date': goal.startDate.toIso8601String().substring(0, 10),
  'target_date': goal.targetDate.toIso8601String().substring(0, 10),
  'status': goal.status.name,
};
