// lib/features/progress/presentation/pages/progress_page.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fittrack/core/router/app_routes.dart';

import 'package:fittrack/features/goals/domain/entities/goal.dart';
import 'package:fittrack/features/goals/presentation/providers/goal_notifiers.dart';

import 'package:fittrack/features/meals/data/providers/meal_providers.dart';

import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:fittrack/features/weight_logs/presentation/providers/weight_log_notifiers.dart';

import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/data/providers/workout_providers.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightHistory = ref.watch(weightHistoryProvider);
    final workouts = ref.watch(workoutsProvider);
    final meals = ref.watch(mealsProvider);
    final goalHistory = ref.watch(goalHistoryProvider);

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

          await Future.wait([
            ref.refresh(weightHistoryProvider.future),
            ref.refresh(workoutsProvider.future),
            ref.refresh(mealsProvider.future),
            ref.refresh(goalHistoryProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //------------------------------------------------------------
            // Weight History
            //------------------------------------------------------------
            const _SectionHeader(title: 'Weight History'),

            const SizedBox(height: 8),

            weightHistory.when(
              loading: () => const _CardShimmer(),

              error: (error, stack) => _ErrorCard(
                message: 'Could not load weight history',
                onRetry: () {
                  ref.invalidate(weightHistoryProvider);
                },
              ),

              data: (List<WeightLog> logs) {
                if (logs.isEmpty) {
                  return _EmptyCard(
                    message: 'No weight logs yet.',
                    actionLabel: 'Log Weight',
                    onAction: () {
                      context.push(AppRoutes.weightLogs);
                    },
                  );
                }

                return Column(
                  children: [
                    _WeightSummaryRow(logs: logs),

                    const SizedBox(height: 12),

                    _WeightChart(logs: logs),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            //------------------------------------------------------------
            // Activity Summary
            //------------------------------------------------------------
            const _SectionHeader(title: 'Activity Summary'),

            const SizedBox(height: 8),

            _StatsRow(
              workoutsAsync: workouts,
              mealsAsync: meals,
              goalsAsync: goalHistory,
            ),

            const SizedBox(height: 24),

            //------------------------------------------------------------
            // Recent Activity
            //------------------------------------------------------------
            const _SectionHeader(title: 'Recent Activity'),

            const SizedBox(height: 8),

            _RecentActivity(
              weightHistory: weightHistory,
              workoutsAsync: workouts,
              mealsAsync: meals,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
//────────────────────────────────────────────────────────────
// Weight Summary Row
//────────────────────────────────────────────────────────────

class _WeightSummaryRow extends StatelessWidget {
  final List<WeightLog> logs;

  const _WeightSummaryRow({required this.logs});

  @override
  Widget build(BuildContext context) {
    final currentWeight = logs.first.weightKg;
    final firstWeight = logs.last.weightKg;

    final change = currentWeight - firstWeight;
    final isGain = change > 0;

    Color? changeColor;
    if (change > 0) {
      changeColor = Colors.red;
    } else if (change < 0) {
      changeColor = Colors.green;
    }

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Current',
            value: '${currentWeight.toStringAsFixed(1)} kg',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(
            label: 'Change',
            value: '${isGain ? '+' : ''}${change.toStringAsFixed(1)} kg',
            valueColor: changeColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(label: 'Entries', value: logs.length.toString()),
        ),
      ],
    );
  }
}

//────────────────────────────────────────────────────────────
// Weight Chart
//────────────────────────────────────────────────────────────

class _WeightChart extends StatelessWidget {
  final List<WeightLog> logs;

  const _WeightChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    final orderedLogs = logs.reversed.toList();

    final spots = List<FlSpot>.generate(
      orderedLogs.length,
      (index) => FlSpot(index.toDouble(), orderedLogs[index].weightKg),
    );

    final weights = orderedLogs.map((e) => e.weightKg).toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);

    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    final minY = (minWeight - 2).floorToDouble();
    final maxY = (maxWeight + 2).ceilToDouble();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
        child: SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,

              borderData: FlBorderData(show: false),

              gridData: FlGridData(show: true, drawVerticalLine: false),

              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 42,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,

                  isCurved: true,

                  barWidth: 3,

                  color: Theme.of(context).colorScheme.primary,

                  dotData: FlDotData(show: spots.length <= 10),

                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
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
//────────────────────────────────────────────────────────────
// Activity Summary
//────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AsyncValue<List<WorkoutEntity>> workoutsAsync;
  final AsyncValue<List<dynamic>> mealsAsync;
  final AsyncValue<List<Goal>> goalsAsync;

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
        goalsAsync.value
            ?.where((goal) => goal.status == GoalStatus.completed)
            .length ??
        0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Workouts', value: workoutCount.toString()),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(label: 'Meals', value: mealCount.toString()),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(label: 'Goals', value: completedGoals.toString()),
        ),
      ],
    );
  }
}

//────────────────────────────────────────────────────────────
// Recent Activity
//────────────────────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  final AsyncValue<List<WeightLog>> weightHistory;
  final AsyncValue<List<WorkoutEntity>> workoutsAsync;
  final AsyncValue<List<dynamic>> mealsAsync;

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
          //--------------------------------------------------
          // Latest Weight
          //--------------------------------------------------
          if (latestWeight != null)
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text('${latestWeight.weightKg.toStringAsFixed(1)} kg'),
              subtitle: Text(_formatDate(latestWeight.loggedAt)),
            ),

          //--------------------------------------------------
          // Latest Workout
          //--------------------------------------------------
          if (latestWorkout != null) ...[
            if (latestWeight != null) const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(latestWorkout.title),
              subtitle: Text(
                '${latestWorkout.durationMins} mins'
                '${latestWorkout.caloriesBurned != null ? ' • ${latestWorkout.caloriesBurned} cal' : ''}',
              ),
            ),
          ],

          //--------------------------------------------------
          // Latest Meal
          //--------------------------------------------------
          if (latestMeal != null) ...[
            if (latestWeight != null || latestWorkout != null)
              const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.restaurant_outlined),
              title: Text(latestMeal.mealName),
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

    final value = DateTime(date.year, date.month, date.day);

    if (value == today) {
      return 'Today';
    }

    if (value == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
//────────────────────────────────────────────────────────────
// Section Header
//────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

//────────────────────────────────────────────────────────────
// Stat Card
//────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
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
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

//────────────────────────────────────────────────────────────
// Loading Card
//────────────────────────────────────────────────────────────

class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

//────────────────────────────────────────────────────────────
// Error Card
//────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),

            const SizedBox(width: 12),

            Expanded(child: Text(message)),

            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

//────────────────────────────────────────────────────────────
// Empty Card
//────────────────────────────────────────────────────────────

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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),

            const SizedBox(height: 12),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 16),

            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

//────────────────────────────────────────────────────────────
// Empty Progress Screen
//────────────────────────────────────────────────────────────

class _EmptyProgress extends StatelessWidget {
  final VoidCallback onAction;

  const _EmptyProgress({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            Text(
              'No progress data yet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Start logging your weight, workouts and meals to see charts and progress over time.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
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
}
