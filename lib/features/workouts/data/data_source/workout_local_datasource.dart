import 'package:fittrack/features/workouts/data/models/workout_model.dart';

abstract interface class WorkoutLocalDataSource {
  Future<List<WorkoutModel>> getCachedWorkouts();
  Future<void> cacheWorkouts(List<WorkoutModel> workouts);
  Future<void> clearCache();
}
