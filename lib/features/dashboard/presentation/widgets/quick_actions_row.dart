// lib/features/dashboard/presentation/widgets/quick_actions_row.dart

import 'package:fittrack/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------------------
        // Row 1
        // ---------------------------
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.monitor_weight_outlined,
                label: 'Weight',
                onTap: () => context.push(AppRoutes.weightLogs),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.restaurant_outlined,
                label: 'Meals',
                onTap: () => context.push(AppRoutes.meals),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.fitness_center_outlined,
                label: 'Workout',
                onTap: () => context.push(AppRoutes.workouts),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ---------------------------
        // Row 2
        // ---------------------------
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.flag_outlined,
                label: 'Goals',
                onTap: () => context.push(AppRoutes.goals),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.insights_outlined,
                label: 'Progress',
                onTap: () => context.push(AppRoutes.progress),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () => context.push(AppRoutes.profile),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
