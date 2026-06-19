// lib/features/goals/domain/usecases/get_goal_history_usecase.dart

import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class GetGoalHistoryUseCase {
  final GoalRepository _repository;
  const GetGoalHistoryUseCase(this._repository);

  Future<List<Goal>> call() => _repository.getGoalHistory();
}