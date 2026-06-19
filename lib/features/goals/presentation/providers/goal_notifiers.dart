// lib/features/goals/presentation/providers/goal_notifiers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fittrack/features/goals/data/providers/goal_providers.dart';
import 'package:fittrack/features/goals/domain/entities/goal.dart';

part 'goal_notifiers.g.dart';

// ... rest of your file is unchanged — the logic was correct,
// it just couldn't see any of these names.
@riverpod
class ActiveGoalNotifier extends _$ActiveGoalNotifier {
  @override
  Future<Goal?> build() {
    return ref.read(getActiveGoalUseCaseProvider)();
  }
}

@riverpod
class GoalHistoryNotifier extends _$GoalHistoryNotifier {
  @override
  Future<List<Goal>> build() {
    return ref.read(getGoalHistoryUseCaseProvider)();
  }
}

// Handles create, complete, AND abandon — all are "mutate a goal" actions
// that originate from user-initiated buttons, never run concurrently
// with each other, and all have the same after-effect: refresh active + history.
@riverpod
class GoalActionNotifier extends _$GoalActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> createGoal(Goal goal) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(createGoalUseCaseProvider)(goal),
    );
    _refreshAfterMutation();
  }

  Future<void> abandonGoal(String goalId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(abandonGoalUseCaseProvider)(goalId),
    );
    _refreshAfterMutation();
  }

  Future<void> completeGoal(String goalId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(completeGoalUseCaseProvider)(goalId),
    );
    _refreshAfterMutation();
  }

  void _refreshAfterMutation() {
    if (!state.hasError) {
      ref.invalidate(activeGoalProvider);
      ref.invalidate(goalHistoryProvider);
    }
  }
}
