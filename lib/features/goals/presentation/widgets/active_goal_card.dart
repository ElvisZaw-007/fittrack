// lib/features/goals/presentation/widgets/active_goal_card.dart

import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';

class ActiveGoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onAbandon;
  final bool isLoading;

  const ActiveGoalCard({
    super.key,
    required this.goal,
    required this.onAbandon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Goal: ${goal.goalType.displayName}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  TextButton.icon(
                    onPressed: onAbandon,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Abandon'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Starting Weight', '${goal.startWeight} kg'),
            const SizedBox(height: 8),
            _buildInfoRow('Target Weight', '${goal.targetWeight} kg'),
            const SizedBox(height: 8),
            _buildInfoRow('Target Date', _formatDate(goal.targetDate)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'You have an active goal. Abandon it to create a new one.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
