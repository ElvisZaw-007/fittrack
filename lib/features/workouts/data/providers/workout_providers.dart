import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source.dart';
import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source_impl.dart';
import 'package:fittrack/features/workouts/data/repositories/workout_repository_impl.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';
import 'package:fittrack/features/workouts/domain/usecases/add_workout_usecase.dart';
import 'package:fittrack/features/workouts/domain/usecases/get_workouts_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final workoutRemoteDataSourceProvider = Provider<WorkoutRemoteDataSource>((
  ref,
) {
  return WorkoutRemoteDataSourceImpl(Supabase.instance.client);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(ref.read(workoutRemoteDataSourceProvider));
});

final getWorkoutsUseCaseProvider = Provider<GetWorkoutsUseCase>((ref) {
  return GetWorkoutsUseCase(ref.read(workoutRepositoryProvider));
});

final addWorkoutUseCaseProvider = Provider<AddWorkoutUseCase>((ref) {
  return AddWorkoutUseCase(ref.read(workoutRepositoryProvider));
});

final workoutsProvider = FutureProvider<List<WorkoutEntity>>((ref) async {
  return ref.read(getWorkoutsUseCaseProvider)();
});
