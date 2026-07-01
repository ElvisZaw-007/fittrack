import 'dart:async';

import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_action_notifier.g.dart';

@riverpod
class MealsNotifier extends _$MealsNotifier {
  @override
  Future<List<MealEntity>> build() async {
    final user = await ref.watch(authStateProvider.future);

    if (user == null) {
      return [];
    }

    return ref.read(getMealsUseCaseProvider)();
  }
}

@riverpod
class TodayCaloriesNotifier extends _$TodayCaloriesNotifier {
  @override
  Future<int> build() async {
    final user = await ref.watch(authStateProvider.future);

    if (user == null) {
      return 0;
    }

    return ref.read(getTodayCaloriesUseCaseProvider)();
  }
}

@riverpod
class MealActionNotifier extends _$MealActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addMeal(MealEntity meal) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(addMealUseCaseProvider)(meal),
    );

    if (!state.hasError) {
      ref.invalidate(mealsProvider);
      ref.invalidate(todayCaloriesProvider);
    }
  }

  Future<void> updateMeal(MealEntity meal) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(updateMealUsecaseProvider)(meal),
    );

    if (!state.hasError) {
      ref.invalidate(mealsProvider);
      ref.invalidate(todayCaloriesProvider);
    }
  }

  Future<void> deleteMeal(String mId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(deleteMealUsecaseProvider)(mId),
    );

    if (!state.hasError) {
      ref.invalidate(mealsProvider);
      ref.invalidate(todayCaloriesProvider);
    }
  }
}
