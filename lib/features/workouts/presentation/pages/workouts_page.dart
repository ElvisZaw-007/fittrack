import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';
import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/presentation/widgets/add_workout_bottom_sheet.dart';
import 'package:fittrack/features/workouts/presentation/widgets/delete_workout_bottom_sheet.dart';
import 'package:fittrack/features/workouts/presentation/widgets/update_workout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fittrack/core/widgets/loading_view.dart';
import 'package:fittrack/core/widgets/error_view.dart';
import 'package:fittrack/core/widgets/empty_state_view.dart';

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
            return EmptyStateView(
              icon: Icons.fitness_center,
              title: 'No workouts yet',
              message: 'Time to get moving — log your first workout.',
              actionLabel: 'Add Workout',
              onAction: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AddWorkoutBottomSheet(),
                );
              },
            );
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return ListTile(
                title: Text(workout.title),
                subtitle: Text(
                  '${workout.durationMins} mins'
                  '${workout.caloriesBurned != null ? ' • ${workout.caloriesBurned} cal' : ''}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleMenuAction(context, ref, value, workout),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingView(message: 'Loading workouts...'),
        error: (error, stackTrace) => ErrorView(
          message: 'Unable to load your workouts.',
          onRetry: () {
            ref.invalidate(workoutsProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddWorkoutBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String value,
    WorkoutEntity workout,
  ) {
    switch (value) {
      case 'edit':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => UpdateWorkoutBottomSheet(workout: workout),
        );
        break;
      case 'delete':
        showModalBottomSheet(
          context: context,
          builder: (_) => DeleteWorkoutBottomSheet(workout: workout),
        );
        break;
    }
  }
}
