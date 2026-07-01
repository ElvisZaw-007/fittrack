import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';

class DeleteWorkoutUsecase {
  final WorkoutRepository _repository;
  const DeleteWorkoutUsecase(this._repository);

  Future<void> call(String wId) {
    return _repository.deleteWorkout(wId);
  }
}
