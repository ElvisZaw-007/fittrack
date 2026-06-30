import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayCaloriesSection extends ConsumerWidget {
  const TodayCaloriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caloriesAsync = ref.watch(todayCaloriesProvider);
    ref.watch(todayCaloriesProvider);

    return caloriesAsync.when(
      data: (calories) {
        return Text('$calories kcal');
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, _) => const Text('Failed to load'),
    );
  }
}
