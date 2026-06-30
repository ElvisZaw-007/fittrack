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
        .from('workouts')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false);

    return response
        .map<WorkoutModel>((json) => WorkoutModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addWorkout(WorkoutModel workout) async {
    await _supabase.from('workouts').insert(workout.toInsertJson());
  }
}
