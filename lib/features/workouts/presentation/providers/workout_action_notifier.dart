import 'dart:async';

import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_action_notifier.g.dart';

@riverpod
class WorkoutActionNotifier extends _$WorkoutActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addWorkout(WorkoutEntity workout) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(addWorkoutUseCaseProvider)(workout),
    );

    if (!state.hasError) {
      ref.invalidate(workoutsProvider);
    }
  }

  Future<void> updateWorkout(WorkoutEntity workout) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(updateWorkoutUseCaseProvider)(workout),
    );

    if (!state.hasError) {
      ref.invalidate(workoutsProvider);
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(deleteWorkoutUseCaseProvider)(workoutId),
    );

    if (!state.hasError) {
      ref.invalidate(workoutsProvider);
    }
  }
}
