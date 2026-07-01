import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source.dart';
import 'package:fittrack/features/workouts/data/models/workout_model.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource remoteDataSource;

  const WorkoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addWorkout(WorkoutEntity workout) async {
    try {
      await remoteDataSource.addWorkout(WorkoutModel.fromEntity(workout));
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<WorkoutEntity>> getWorkouts() async {
    try {
      final workouts = await remoteDataSource.getWorkouts();

      return workouts.map((e) => e.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> updateWorkout(WorkoutEntity workout) async {
    try {
      await remoteDataSource.updateWorkout(WorkoutModel.fromEntity(workout));
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteWorkout(String wId) async {
    try {
      await remoteDataSource.deleteWorkout(wId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
