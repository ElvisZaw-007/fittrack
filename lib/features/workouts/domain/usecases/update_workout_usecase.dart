import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';

class UpdateWorkoutUseCase {
  final WorkoutRepository repository;

  const UpdateWorkoutUseCase(this.repository);
  Future<void> call(WorkoutEntity workout) {
    return repository.updateWorkout(workout);
  }
}
