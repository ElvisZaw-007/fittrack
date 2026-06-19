// lib/features/goals/domain/usecases/complete_goal_usecase.dart


import '../../../../core/errors/failures.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class CompleteGoalUseCase {
  final GoalRepository _repository;
  const CompleteGoalUseCase(this._repository);

  Future<Goal> call(String goalId) async {
    // Validation: ensure goal exists and is active before completing
    final activeGoal = await _repository.getActiveGoal();
    
    if (activeGoal == null) {
      throw const InvalidGoalFailure('No active goal to complete.');
    }
    
    if (activeGoal.id != goalId) {
      throw const InvalidGoalFailure('Cannot complete a non-active goal.');
    }
    
    return _repository.updateGoalStatus(
      goalId: goalId,
      status: GoalStatus.completed,
    );
  }
}