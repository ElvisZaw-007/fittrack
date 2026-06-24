// lib/features/goals/presentation/pages/create_goal_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/goal_notifiers.dart';
import '../widgets/active_goal_card.dart';
import '../widgets/goal_form.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(goalActionProvider, (previous, next) {
      if (!mounted) return;

      next.whenOrNull(
        error: (error, stackTrace) {
          String message = 'Operation failed';

          if (error is GoalAlreadyActiveFailure) {
            message = error.message;
          } else if (error is InvalidGoalFailure) {
            message = error.message;
          } else if (error is InvalidGoalDateFailure) {
            message = error.message;
          } else if (error is ServerFailure) {
            message = error.message;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Operation completed successfully!'),
              ),
            );
          }
        },
      );
    });

    final activeGoalAsync = ref.watch(activeGoalProvider);
    final mutationState = ref.watch(goalActionProvider);

    final isMutating = mutationState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push(AppRoutes.goalHistory);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: activeGoalAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(activeGoalProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),

          data: (activeGoal) {
            // Active Goal Exists
            if (activeGoal != null) {
              return ActiveGoalCard(
                goal: activeGoal,

                currentWeight: activeGoal.startWeight,

                onComplete: () {
                  final id = activeGoal.id;
                  if (id == null) return;
                  ref.read(goalActionProvider.notifier).completeGoal(id);
                },

                onAbandon: () {
                  ref
                      .read(goalActionProvider.notifier)
                      .abandonGoal(activeGoal.id!);
                },
              );
            }

            // No Active Goal
            return CreateGoalForm(
              isLoading: isMutating,
              onSubmit: (goal) {
                ref.read(goalActionProvider.notifier).createGoal(goal);
              },
            );
          },
        ),
      ),
    );
  }
}
