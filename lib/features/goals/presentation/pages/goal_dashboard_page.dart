import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/goal_notifiers.dart';
import '../widgets/active_goal_card.dart';
import '../widgets/goal_history_list.dart';

class GoalDashboardPage extends ConsumerWidget {
  const GoalDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoal = ref.watch(activeGoalProvider);
    final history = ref.watch(goalHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goal Dashboard')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            activeGoal.when(
              loading: () => const CircularProgressIndicator(),

              error: (e, _) => Text(e.toString()),

              data: (goal) {
                if (goal == null) {
                  return const Text('No active goal');
                }

                return ActiveGoalCard(
                  goal: goal,

                  onComplete: () {
                    ref
                        .read(goalActionProvider.notifier)
                        .completeGoal(goal.id!);
                  },

                  onAbandon: () {
                    ref.read(goalActionProvider.notifier).abandonGoal(goal.id!);
                  },
                  currentWeight: goal.startWeight,
                );
              },
            ),

            const SizedBox(height: 24),

            history.when(
              loading: () => const CircularProgressIndicator(),

              error: (e, _) => Text(e.toString()),

              data: (goals) {
                return GoalHistoryList(goals: goals);
              },
            ),
          ],
        ),
      ),
    );
  }
}
