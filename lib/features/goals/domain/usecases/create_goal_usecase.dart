// lib/features/goals/domain/usecases/create_goal_usecase.dart
// lib/features/goals/domain/usecases/create_goal_usecase.dart

import '../../../../core/errors/failures.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class CreateGoalUseCase {
  final GoalRepository _repository;

  const CreateGoalUseCase(this._repository);

  Future<Goal> call(Goal goal) async {
    if (!goal.targetDate.isAfter(goal.startDate)) {
      throw const InvalidGoalDateFailure();
    }

    switch (goal.goalType) {
      case GoalType.loseWeight:
        if (goal.targetWeight >= goal.startWeight) {
          throw const InvalidGoalFailure(
            'Target weight must be lower than start weight.',
          );
        }
        break;

      case GoalType.gainWeight:
        if (goal.targetWeight <= goal.startWeight) {
          throw const InvalidGoalFailure(
            'Target weight must be greater than start weight.',
          );
        }
        break;

      case GoalType.maintainWeight:
        if (goal.targetWeight != goal.startWeight) {
          throw const InvalidGoalFailure(
            'Target weight must equal start weight.',
          );
        }
        break;
    }

    return _repository.createGoal(goal);
  }
}
