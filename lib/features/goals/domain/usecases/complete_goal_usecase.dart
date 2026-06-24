import 'package:fittrack/features/goals/domain/repositories/goal_repository.dart';

import '../entities/goal.dart';

class CompleteGoalUseCase {
  final GoalRepository _repository;

  const CompleteGoalUseCase(this._repository);

  Future<Goal> call(String goalId) {
    return _repository.completeGoal(goalId);
  }
}
