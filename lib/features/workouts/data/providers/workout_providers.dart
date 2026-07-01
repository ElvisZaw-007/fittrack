import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source.dart';
import 'package:fittrack/features/workouts/data/data_source/workout_remote_data_source_impl.dart';
import 'package:fittrack/features/workouts/data/repositories/workout_repository_impl.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/domain/repositories/workout_repository.dart';
import 'package:fittrack/features/workouts/domain/usecases/add_workout_usecase.dart';
import 'package:fittrack/features/workouts/domain/usecases/delete_workout_usecase.dart';
import 'package:fittrack/features/workouts/domain/usecases/get_workouts_usecase.dart';
import 'package:fittrack/features/workouts/domain/usecases/update_workout_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'workout_providers.g.dart';

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

final updateWorkoutUseCaseProvider = Provider<UpdateWorkoutUseCase>((ref) {
  return UpdateWorkoutUseCase(ref.read(workoutRepositoryProvider));
});

final deleteWorkoutUseCaseProvider = Provider<DeleteWorkoutUsecase>((ref) {
  return DeleteWorkoutUsecase(ref.read(workoutRepositoryProvider));
});

@riverpod
class WorkoutsNotifier extends _$WorkoutsNotifier {
  @override
  Future<List<WorkoutEntity>> build() async {
    final user = await ref.watch(authStateProvider.future);

    if (user == null) {
      return [];
    }

    return ref.read(getWorkoutsUseCaseProvider)();
  }
}
