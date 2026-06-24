// lib/features/goals/domain/entities/goal.dart

enum GoalType { loseWeight, gainWeight, maintainWeight }

enum GoalStatus { active, completed, abandoned }

extension GoalTypeX on GoalType {
  String get displayName => switch (this) {
    GoalType.loseWeight => 'Lose Weight',
    GoalType.gainWeight => 'Gain Weight',
    GoalType.maintainWeight => 'Maintain Weight',
  };

  //DB value mapper
  String get dbValue => switch (this) {
    GoalType.loseWeight => 'lose_weight',
    GoalType.gainWeight => 'gain_weight',
    GoalType.maintainWeight => 'maintain_weight',
  };

  static GoalType fromDb(String value) => switch (value) {
    'lose_weight' => GoalType.loseWeight,
    'gain_weight' => GoalType.gainWeight,
    'maintain_weight' => GoalType.maintainWeight,
    _ => throw Exception('Invalid goal type: $value'),
  };
}

class Goal {
  final String? id; // null until the database generates one
  final GoalType goalType;
  final double startWeight;
  final double targetWeight;
  final DateTime startDate;
  final DateTime targetDate;
  final GoalStatus status;

  const Goal({
    this.id,
    required this.goalType,
    required this.startWeight,
    required this.targetWeight,
    required this.startDate,
    required this.targetDate,
    this.status = GoalStatus.active, // sensible default for new goals
  });
  GoalType get type => goalType;
}
