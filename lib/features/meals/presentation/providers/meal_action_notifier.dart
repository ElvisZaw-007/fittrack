import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/meal_entity.dart';

class MealActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addMeal(MealEntity meal) async {
    state = const AsyncLoading();

    final authState =
        await ref.read(authStateProvider.future);

    if (authState == null) {
      state = AsyncError(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return;
    }

    state = await AsyncValue.guard(() async {
      await ref.read(addMealUseCaseProvider)(meal);

      ref.invalidate(mealsProvider);
      ref.invalidate(todayCaloriesProvider);
    });
  }
}

final mealActionNotifierProvider =
    AsyncNotifierProvider<MealActionNotifier, void>(
  MealActionNotifier.new,
);