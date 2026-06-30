import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addWorkout(WorkoutEntity workout) async {
    state = const AsyncLoading();

    final authState = await ref.read(authStateProvider.future);

    if (authState == null) {
      state = AsyncError(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return;
    }

    state = await AsyncValue.guard(() async {
      await ref.read(addWorkoutUseCaseProvider)(workout);

      ref.invalidate(workoutsProvider);
    });
  }
}

final workoutActionNotifierProvider =
    AsyncNotifierProvider<WorkoutActionNotifier, void>(
      WorkoutActionNotifier.new,
    );
