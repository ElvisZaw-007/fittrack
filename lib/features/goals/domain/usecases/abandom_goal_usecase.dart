// lib/features/goals/domain/usecases/abandon_goal_usecase.dart


import '../../../../core/errors/failures.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class AbandonGoalUseCase {
  final GoalRepository _repository;
  const AbandonGoalUseCase(this._repository);

  Future<Goal> call(String goalId) async {
    // Validation: ensure goal exists and is active before abandoning
    final activeGoal = await _repository.getActiveGoal();
    
    if (activeGoal == null) {
      throw const InvalidGoalFailure('No active goal to abandon.');
    }
    
    if (activeGoal.id != goalId) {
      throw const InvalidGoalFailure('Cannot abandon a non-active goal.');
    }
    
    return _repository.updateGoalStatus(
      goalId: goalId,
      status: GoalStatus.abandoned,
    );
  }
}