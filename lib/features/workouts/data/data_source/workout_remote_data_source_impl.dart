import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source.dart';
import 'package:fittrack/features/workouts/data/models/workout_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final SupabaseClient _supabase;

  const WorkoutRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    final userId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('workout_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false);

    return response
        .map<WorkoutModel>((json) => WorkoutModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addWorkout(WorkoutModel workout) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('workout_logs')
          .insert(workout.toInsertJson(userId: userId));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateWorkout(WorkoutModel workout) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('workout_logs')
          .update(workout.toUpdateJson())
          .eq('id', workout.id)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkout(String wId) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('workout_logs')
          .delete()
          .eq('id', wId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
