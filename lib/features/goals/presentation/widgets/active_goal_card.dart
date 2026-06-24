import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_progress_extension.dart';

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
            Text(goal.goalType.displayName),

            const SizedBox(height: 16),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 8),

            Text('${(progress * 100).toStringAsFixed(0)}%'),

            const SizedBox(height: 8),

            Text('${goal.remainingDays} days remaining'),
          ],
        ),
      ),
    );
  }
}
