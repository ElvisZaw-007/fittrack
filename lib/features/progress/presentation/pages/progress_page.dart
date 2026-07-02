// lib/features/progress/presentation/pages/progress_page.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fittrack/core/router/app_routes.dart';
import 'package:fittrack/features/goals/presentation/providers/goal_notifiers.dart';
import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:fittrack/features/weight_logs/presentation/providers/weight_log_notifiers.dart';
import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightHistory = ref.watch(weightHistoryProvider);
    final workouts = ref.watch(workoutsProvider);
    final meals = ref.watch(mealsProvider);
    final goalHistory = ref.watch(goalHistoryProvider);

    // Determine overall empty state — no data at all across all features
    final allEmpty =
        (weightHistory.value?.isEmpty ?? true) &&
        (workouts.value?.isEmpty ?? true) &&
        (meals.value?.isEmpty ?? true);

    if (allEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: _EmptyProgress(
          onAction: () => context.push(AppRoutes.weightLogs),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weightHistoryProvider);
          ref.invalidate(workoutsProvider);
          ref.invalidate(mealsProvider);
          ref.invalidate(goalHistoryProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Weight chart section
            const _SectionHeader(title: 'Weight History'),
            const SizedBox(height: 8),
            weightHistory.when(
              loading: () => const _CardShimmer(),
              error: (e, _) => _ErrorCard(
                message: 'Could not load weight data',
                onRetry: () => ref.invalidate(weightHistoryProvider),
              ),
              data: (logs) => logs.isEmpty
                  ? _EmptyCard(
                      message: 'No weight logs yet',
                      actionLabel: 'Log Weight',
                      onAction: () => context.push(AppRoutes.weightLogs),
                    )
                  : Column(
                      children: [
                        _WeightSummaryRow(logs: logs),
                        const SizedBox(height: 12),
                        _WeightChart(logs: logs),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            // Stats row — totals across all features
            const _SectionHeader(title: 'Activity Summary'),
            const SizedBox(height: 8),
            _StatsRow(
              workoutsAsync: workouts,
              mealsAsync: meals,
              goalsAsync: goalHistory,
            ),

            const SizedBox(height: 24),

            // Recent activity
            const _SectionHeader(title: 'Recent Activity'),
            const SizedBox(height: 8),
            _RecentActivity(
              weightHistory: weightHistory,
              workoutsAsync: workouts,
              mealsAsync: meals,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Weight summary row ────────────────────────────────────────────────────

class _WeightSummaryRow extends StatelessWidget {
  final List<dynamic> logs; // WeightLog list

  const _WeightSummaryRow({required this.logs});

  @override
  Widget build(BuildContext context) {
    // logs are ordered descending — index 0 is latest
    final current = logs.first.weightKg as double;
    final earliest = logs.last.weightKg as double;
    final change = current - earliest;
    final isGain = change > 0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Current',
            value: '${current.toStringAsFixed(1)} kg',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Change',
            value: '${isGain ? '+' : ''}${change.toStringAsFixed(1)} kg',
            valueColor: change == 0
                ? null
                : (isGain ? Colors.red.shade700 : Colors.green.shade700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(label: 'Entries', value: '${logs.length}'),
        ),
      ],
    );
  }
}

// ─── Weight line chart ─────────────────────────────────────────────────────

class _WeightChart extends StatelessWidget {
  final List<dynamic> logs;

  const _WeightChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    // Reverse so oldest is on the left (chart reads left→right)
    final reversed = logs.reversed.toList();

    final spots = List.generate(reversed.length, (i) {
      final weight = reversed[i].weightKg as double;
      return FlSpot(i.toDouble(), weight);
    });

    final weights = spots.map((s) => s.y).toList();
    final minY = (weights.reduce((a, b) => a < b ? a : b) - 2).floorToDouble();
    final maxY = (weights.reduce((a, b) => a > b ? a : b) + 2).ceilToDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show:
                        spots.length <= 10, // only show dots on small datasets
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Stats row ─────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AsyncValue<dynamic> workoutsAsync;
  final AsyncValue<dynamic> mealsAsync;
  final AsyncValue<dynamic> goalsAsync;

  const _StatsRow({
    required this.workoutsAsync,
    required this.mealsAsync,
    required this.goalsAsync,
  });

  @override
  Widget build(BuildContext context) {
    final workoutCount = workoutsAsync.value?.length ?? 0;
    final mealCount = mealsAsync.value?.length ?? 0;
    final completedGoals =
        (goalsAsync.value as List?)
            ?.where((g) => g.status.name == 'completed')
            .length ??
        0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Workouts', value: '$workoutCount'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(label: 'Meals', value: '$mealCount'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(label: 'Goals Done', value: '$completedGoals'),
        ),
      ],
    );
  }
}

// ─── Recent activity ───────────────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  final AsyncValue<dynamic> weightHistory;
  final AsyncValue<dynamic> workoutsAsync;
  final AsyncValue<dynamic> mealsAsync;

  const _RecentActivity({
    required this.weightHistory,
    required this.workoutsAsync,
    required this.mealsAsync,
  });

  @override
  Widget build(BuildContext context) {
    final latestWeight = weightHistory.value?.isNotEmpty == true
        ? weightHistory.value!.first
        : null;
    final latestWorkout = workoutsAsync.value?.isNotEmpty == true
        ? workoutsAsync.value!.first
        : null;
    final latestMeal = mealsAsync.value?.isNotEmpty == true
        ? mealsAsync.value!.first
        : null;

    if (latestWeight == null && latestWorkout == null && latestMeal == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        children: [
          if (latestWeight != null)
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text('${latestWeight.weightKg} kg'),
              subtitle: Text(_formatDate(latestWeight.loggedAt)),
            ),
          if (latestWorkout != null) ...[
            if (latestWeight != null) const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(latestWorkout.title as String),
              subtitle: Text(
                '${latestWorkout.durationMins} mins'
                '${latestWorkout.caloriesBurned != null ? ' • ${latestWorkout.caloriesBurned} cal' : ''}',
              ),
            ),
          ],
          if (latestMeal != null) ...[
            if (latestWeight != null || latestWorkout != null)
              const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.restaurant_outlined),
              title: Text(latestMeal.mealName as String),
              subtitle: Text('${latestMeal.calories} kcal'),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
  );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    ),
  );
}

class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) => const Card(
    child: SizedBox(
      height: 180,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyCard({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(message),
          const SizedBox(height: 8),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}

class _EmptyProgress extends StatelessWidget {
  final VoidCallback onAction;
  const _EmptyProgress({required this.onAction});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'No progress data yet',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging workouts, meals, and weight entries to track your progress over time.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.monitor_weight_outlined),
            label: const Text('Log Weight'),
          ),
        ],
      ),
    ),
  );
}
