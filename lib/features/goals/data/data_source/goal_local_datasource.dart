import 'package:fittrack/features/goals/data/models/goal_model.dart';

abstract interface class GoalLocalDataSource {
  Future<GoalModel?> getCachedActiveGoal();
  Future<List<GoalModel>> getCachedGoalHistory();
  Future<void> cacheActiveGoal(GoalModel? goal);
  Future<void> cacheGoalHistory(List<GoalModel> goals);
  Future<void> clearCache();
}
