import 'package:fittrack/features/goals/data/data_source/goal_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/goal_model.dart';

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final SupabaseClient _supabase;
  const GoalRemoteDataSourceImpl(this._supabase);

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    final userId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('goals')
        .insert(goalToInsertJson(goal.toEntity(), userId: userId))
        .select()
        .single();

    return GoalModel.fromJson(response);
  }

  @override
  Future<GoalModel?> getActiveGoal() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await _supabase
        .from('goals')
        .select()
        .eq('user_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    if (response == null) return null;
    return GoalModel.fromJson(response);
  }

  @override
  Future<GoalModel> updateGoalStatus({
    required String goalId,
    required String status,
  }) async {
    final response = await _supabase
        .from('goals')
        .update({'status': status})
        .eq('id', goalId)
        .select()
        .single();

    return GoalModel.fromJson(response);
  }

  @override
  Future<GoalModel> abandonGoal(String goalId) async {
    final response = await _supabase
        .from('goals')
        .update({'status': 'abandoned'})
        .eq('id', goalId)
        .select()
        .single();

    return GoalModel.fromJson(response);
  }

  @override
  Future<List<GoalModel>> getGoalHistory() async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) return [];

    final response = await _supabase
        .from('goals')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => GoalModel.fromJson(json)).toList();
  }
}
