// lib/features/goals/data/repositories/supabase_goal_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fittrack/core/errors/failures.dart';
import '../models/goal_model.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../data_source/goal_remote_datasource.dart';

class SupabaseGoalRepository implements GoalRepository {
  final GoalRemoteDataSource _remoteDataSource;
  const SupabaseGoalRepository(this._remoteDataSource);

  @override
  Future<Goal?> getActiveGoal() async {
    final model = await _remoteDataSource.getActiveGoal();

    return model?.toEntity();
  }

  @override
  Future<Goal> createGoal(Goal goal) async {
    try {
      final model = GoalModel.fromEntity(goal);
      final created = await _remoteDataSource.createGoal(model);

      return created.toEntity();
    } on PostgrestException catch (e) {
      //UNIQUE INDEX
      if (e.code == '23505') {
        throw const GoalAlreadyActiveFailure();
      }
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<Goal> updateGoalStatus({
    required String goalId,
    required GoalStatus status,
  }) async {
    try {
      final updated = await _remoteDataSource.updateGoalStatus(
        goalId: goalId,
        status: status.name,
      );

      return updated.toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<Goal>> getGoalHistory() async {
    final models = await _remoteDataSource.getGoalHistory();

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Goal> completeGoal(String goalId) async {
    final model = await _remoteDataSource.updateGoalStatus(
      goalId: goalId,
      status: 'completed',
    );
    return model.toEntity();
  }

  @override
  Future<Goal> abandonGoal(String goalId) async {
    try {
      final updated = await _remoteDataSource.abandonGoal(goalId);

      return updated.toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
