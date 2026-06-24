import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../providers/weight_log_notifiers.dart';

class WeightSummarySection extends ConsumerWidget {
  const WeightSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestWeight = ref.watch(latestWeightProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weight',
              style: Theme.of(context).textTheme.labelLarge,
            ),

            const SizedBox(height: 8),

            latestWeight.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              error: (e, _) => _SectionError(
                message: 'Could not load weight',
                onRetry: () => ref.invalidate(latestWeightProvider),
              ),

              data: (log) {
                if (log == null) {
                  return _EmptyState(
                    message: 'No weight logged yet',
                    actionLabel: 'Log Weight',
                    onAction: () => context.push(AppRoutes.weightLogs),
                  );
                }

                return Row(
                  children: [
                    Text(
                      '${log.weightKg} kg',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const Spacer(),

                    Text(
                      '${log.loggedAt.day}/${log.loggedAt.month}/${log.loggedAt.year}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SectionError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message),

        const SizedBox(height: 12),

        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
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
    return Column(
      children: [
        Text(message),

        const SizedBox(height: 12),

        ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
