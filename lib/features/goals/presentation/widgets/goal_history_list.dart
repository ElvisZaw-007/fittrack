import 'package:flutter/material.dart';

import '../../domain/entities/goal.dart';

class GoalHistoryList extends StatelessWidget {
  final List<Goal> goals;

  const GoalHistoryList({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Text('No goal history');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Goal History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...goals.map(
          (goal) => Card(
            child: ListTile(
              title: Text(goal.goalType.displayName),

              subtitle: Text('${goal.startWeight} → ${goal.targetWeight} kg'),

              trailing: Text(goal.status.name),
            ),
          ),
        ),
      ],
    );
  }
}
