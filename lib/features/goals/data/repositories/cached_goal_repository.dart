import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/goals/data/data_source/goal_local_datasource.dart';

import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';

import '../models/goal_model.dart';

class CachedGoalRepository implements GoalRepository {
  final GoalRepository _remote;
  final GoalLocalDataSource _local;

  const CachedGoalRepository(this._remote, this._local);

  @override
  Future<Goal?> getActiveGoal() async {
    try {
      final goal = await _remote.getActiveGoal();

      await _local.cacheActiveGoal(
        goal == null ? null : GoalModel.fromEntity(goal),
      );

      return goal;
    } on NetworkFailure {
      final cached = await _local.getCachedActiveGoal();

      return cached?.toEntity();
    }
  }

  @override
  Future<List<Goal>> getGoalHistory() async {
    try {
      final goals = await _remote.getGoalHistory();

      await _local.cacheGoalHistory(
        goals.map((goal) => GoalModel.fromEntity(goal)).toList(),
      );

      return goals;
    } on NetworkFailure {
      final cached = await _local.getCachedGoalHistory();

      if (cached.isEmpty) rethrow;

      return cached.map((goal) => goal.toEntity()).toList();
    }
  }

  @override
  Future<Goal> createGoal(Goal goal) async {
    final result = await _remote.createGoal(goal);

    await _local.clearCache();

    return result;
  }

  @override
  Future<Goal> abandonGoal(String goalId) async {
    final result = await _remote.abandonGoal(goalId);

    await _local.clearCache();

    return result;
  }

  @override
  Future<Goal> completeGoal(String goalId) async {
    final result = await _remote.completeGoal(goalId);

    await _local.clearCache();

    return result;
  }

  @override
  Future<Goal> updateGoalStatus({
    required String goalId,
    required GoalStatus status,
  }) {
    // TODO: implement updateGoalStatus
    throw UnimplementedError();
  }
}
