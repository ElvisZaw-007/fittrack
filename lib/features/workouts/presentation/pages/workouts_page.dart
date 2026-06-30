import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';
import 'package:fittrack/features/workouts/presentation/widgets/add_workout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutsPage extends ConsumerWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: workoutsAsync.when(
        data: (workouts) {
          if (workouts.isEmpty) {
            return const Center(child: Text('No workouts yet'));
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return ListTile(
                title: Text(workout.title),
                subtitle: Text('${workout.durationMins} mins'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return const AddWorkoutBottomSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
