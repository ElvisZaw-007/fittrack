import 'package:flutter/material.dart';

import '../../../goals/domain/entities/goal.dart';
import '../../../goals/domain/entities/goal_progress_extension.dart';


class ActiveGoalCard extends StatelessWidget {
  final Goal goal;
  final double currentWeight;

  final VoidCallback onComplete;
  final VoidCallback onAbandon;

  const ActiveGoalCard({
    super.key,
    required this.goal,
    required this.currentWeight,
    required this.onComplete,
    required this.onAbandon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercent(currentWeight);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              goal.goalType.displayName,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 8),

            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
            ),

            const SizedBox(height: 8),

            Text('${goal.remainingDays} days remaining'),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,
                    child: const Text('Complete'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton(
                    onPressed: onAbandon,
                    child: const Text('Abandon'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}