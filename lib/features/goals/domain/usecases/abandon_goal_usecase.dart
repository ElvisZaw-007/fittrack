import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class AbandonGoalUseCase {
  final GoalRepository _repository;

  const AbandonGoalUseCase(this._repository);

  Future<Goal> call(String goalId) {
    return _repository.abandonGoal(goalId);
  }
  
}
