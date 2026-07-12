import 'package:fittrack/core/errors/failures.dart';

import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';

import '../data_source/workout_local_datasource.dart';
import '../models/workout_model.dart';

class CachedWorkoutRepository implements WorkoutRepository {
  final WorkoutRepository _remote;
  final WorkoutLocalDataSource _local;

  const CachedWorkoutRepository(this._remote, this._local);

  @override
  Future<List<WorkoutEntity>> getWorkouts() async {
    try {
      final workouts = await _remote.getWorkouts();

      await _local.cacheWorkouts(
        workouts.map((workout) => WorkoutModel.fromEntity(workout)).toList(),
      );

      return workouts;
    } on NetworkFailure {
      final cached = await _local.getCachedWorkouts();

      if (cached.isEmpty) {
        rethrow;
      }

      return cached.map((workout) => workout.toEntity()).toList();
    }
  }

  @override
  Future<void> addWorkout(WorkoutEntity workout) async {
    await _remote.addWorkout(workout);

    await _local.clearCache();
  }

  @override
  Future<void> updateWorkout(WorkoutEntity workout) async {
    await _remote.updateWorkout(workout);

    await _local.clearCache();
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _remote.deleteWorkout(id);

    await _local.clearCache();
  }
}
