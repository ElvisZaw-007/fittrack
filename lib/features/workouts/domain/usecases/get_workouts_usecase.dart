import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';

class GetWorkoutsUseCase {
  final WorkoutRepository repository;

  const GetWorkoutsUseCase(this.repository);

  Future<List<WorkoutEntity>> call() {
    return repository.getWorkouts();
  }
}