// lib/features/goals/domain/repositories/goal_repository.dart

import '../entities/goal.dart';

abstract interface class GoalRepository {
  Future<Goal?> getActiveGoal();
  Future<List<Goal>> getGoalHistory();
  Future<Goal> createGoal(Goal goal);
  Future<Goal> abandonGoal(String goalId);
  Future<Goal> updateGoalStatus({
    required String goalId,
    required GoalStatus status,
  });
}