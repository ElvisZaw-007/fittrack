import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';

class AddWorkoutUseCase {
  final WorkoutRepository repository;

  const AddWorkoutUseCase(this.repository);
  Future<void> call(WorkoutEntity workout) {
    return repository.addWorkout(workout);
  }
}
