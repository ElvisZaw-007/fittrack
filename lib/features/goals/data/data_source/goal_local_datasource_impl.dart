import 'dart:convert';

import 'package:fittrack/core/hive/hive_service.dart';
import 'package:hive/hive.dart';

import '../models/goal_model.dart';
import 'goal_local_datasource.dart';

class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  static const _activeGoalKey = 'cached_active_goal';
  static const _goalHistoryKey = 'cached_goal_history';

  Box<String> get _box => HiveService.goalsBox;

  @override
  Future<GoalModel?> getCachedActiveGoal() async {
    final raw = _box.get(_activeGoalKey);

    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;

    return GoalModel.fromJson(json);
  }

  @override
  Future<List<GoalModel>> getCachedGoalHistory() async {
    final raw = _box.get(_goalHistoryKey);

    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;

    return list
        .map((item) => GoalModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheActiveGoal(GoalModel? goal) async {
    // Important:
    // null means "no active goal"
    // so we REMOVE the cache key entirely.
    if (goal == null) {
      await _box.delete(_activeGoalKey);
      return;
    }

    final json = jsonEncode(goal.toJson());

    await _box.put(_activeGoalKey, json);
  }

  @override
  Future<void> cacheGoalHistory(List<GoalModel> goals) async {
    final json = jsonEncode(goals.map((goal) => goal.toJson()).toList());

    await _box.put(_goalHistoryKey, json);
  }

  @override
  Future<void> clearCache() async {
    await Future.wait([
      _box.delete(_activeGoalKey),
      _box.delete(_goalHistoryKey),
    ]);
  }
}
