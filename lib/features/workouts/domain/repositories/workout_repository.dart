import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';

abstract interface class WorkoutRepository {
  Future<List<WorkoutEntity>> getWorkouts();

  Future<void> addWorkout(WorkoutEntity workout);
}
