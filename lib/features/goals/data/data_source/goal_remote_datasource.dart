import 'package:fittrack/features/goals/data/models/goal_model.dart';

abstract interface class GoalRemoteDataSource {
  Future<GoalModel> createGoal(GoalModel goal);
  Future<GoalModel?> getActiveGoal();
  Future<GoalModel> abandonGoal(String goalId);
  Future<GoalModel> updateGoalStatus({
    required String goalId,
    required String status,
  });
  Future<List<GoalModel>> getGoalHistory();
}
