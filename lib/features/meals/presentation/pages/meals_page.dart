import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/meal_providers.dart';
import '../widgets/add_meal_bottom_sheet.dart';

class MealsPage extends ConsumerWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      body: mealsAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return const Center(child: Text('No meals yet'));
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return ListTile(
                title: Text(meal.mealName),
                subtitle: Text(
                  '${meal.calories} kcal • '
                  '${meal.loggedAt.toLocal()}',
                ),
              );
            },
          );
        },
        loading: () => const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, _) => const Center(child: Text('Failed to load meals')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return const AddMealBottomSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
