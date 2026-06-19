// lib/features/goals/domain/usecases/get_active_goal_usecase.dart

import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class GetActiveGoalUseCase {
  final GoalRepository _repository;
  const GetActiveGoalUseCase(this._repository);

  Future<Goal?> call() => _repository.getActiveGoal();
}