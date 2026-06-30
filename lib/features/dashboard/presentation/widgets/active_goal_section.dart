import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../goals/presentation/providers/goal_notifiers.dart';
import '../../../weight_logs/presentation/providers/weight_log_notifiers.dart';
import '../../../weight_logs/presentation/widgets/active_goal_card.dart';


class ActiveGoalSection extends ConsumerWidget {
  const ActiveGoalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoal = ref.watch(activeGoalProvider);
    final latestWeight = ref.watch(latestWeightProvider);

    return activeGoal.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),

      error: (e, _) => _SectionError(
        message: 'Could not load goal',
        onRetry: () => ref.invalidate(activeGoalProvider),
      ),

      data: (goal) {
        if (goal == null) {
          return _EmptyState(
            message: 'No active goal',
            actionLabel: 'Create Goal',
            onAction: () => context.push(AppRoutes.goals),
          );
        }

        // valueOrNull replacement
        final weightData = latestWeight.asData?.value;

        final currentWeight = weightData?.weightKg ?? goal.startWeight;

        return ActiveGoalCard(
          goal: goal,
          currentWeight: currentWeight,

          onComplete: () =>
              ref.read(goalActionProvider.notifier).completeGoal(goal.id!),

          onAbandon: () =>
              ref.read(goalActionProvider.notifier).abandonGoal(goal.id!),
        );
      },
    );
  }
}

class _SectionError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SectionError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(message),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(message),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
