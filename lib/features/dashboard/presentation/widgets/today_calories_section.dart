// lib/features/dashboard/presentation/widgets/today_calories_section.dart
import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayCaloriesSection extends ConsumerWidget {
  const TodayCaloriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider watches systematically once a time
    final caloriesAsync = ref.watch(todayCaloriesProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Calories",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            caloriesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Could not load calories',
                    style: TextStyle(color: Colors.red),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () => ref.invalidate(todayCaloriesProvider),
                  ),
                ],
              ),
              data: (kcal) => Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$kcal kcal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
