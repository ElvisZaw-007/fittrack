import 'package:fittrack/features/workouts/data/models/workout_model.dart';

abstract interface class WorkoutRemoteDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<void> addWorkout(WorkoutModel workout);
  Future<void> updateWorkout(WorkoutModel workout);
  Future<void> deleteWorkout(String wId);
}
