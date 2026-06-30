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
      print('INSERT SUCCESS');
    } catch (e, st) {
      print('INSERT ERROR: $e');
      print(st);
      rethrow;
    }
  }
}
