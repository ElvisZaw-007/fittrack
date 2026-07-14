// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:fittrack/core/router/app_routes.dart';

import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/auth/data/providers/auth_providers.dart';

import 'package:fittrack/features/dashboard/presentation/widgets/active_goal_section.dart';
import 'package:fittrack/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:fittrack/features/dashboard/presentation/widgets/today_calories_section.dart';
import 'package:fittrack/features/dashboard/presentation/widgets/weight_summary_section.dart';

import 'package:fittrack/features/goals/presentation/providers/goal_notifiers.dart';
import 'package:fittrack/features/meals/data/providers/meal_providers.dart';
import 'package:fittrack/features/weight_logs/presentation/providers/weight_log_notifiers.dart';

import 'package:fittrack/features/profile/presentation/providers/profile_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    final authState = ref.watch(authStateProvider);

    final fallbackName = authState.asData?.value?.email ?? 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack'),

        actions: [
          IconButton(
            tooltip: 'Profile',

            icon: const Icon(Icons.person_outline),

            onPressed: () {
              context.push(AppRoutes.profile);
            },
          ),

          IconButton(
            tooltip: 'Logout',

            icon: const Icon(Icons.logout),

            onPressed: () async {
              await ref.read(logoutUseCaseProvider)();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Profile refresh

          await ref.read(profileProvider.notifier).refresh();

          // Dashboard sections refresh

          ref.invalidate(latestWeightProvider);

          ref.invalidate(activeGoalProvider);

          ref.invalidate(todayCaloriesProvider);

          await Future.wait([
            ref.refresh(latestWeightProvider.future),

            ref.refresh(activeGoalProvider.future),

            ref.refresh(todayCaloriesProvider.future),
          ]);
        },

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            profileState.when(
              loading: () => Text(
                'Hello, $fallbackName',

                style: Theme.of(context).textTheme.headlineSmall,
              ),

              error: (_, _) => Text(
                'Hello, $fallbackName',

                style: Theme.of(context).textTheme.headlineSmall,
              ),

              data: (profile) {
                final name = profile?.name ?? fallbackName;

                return Text(
                  'Hello, $name',

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const WeightSummarySection(),

            const SizedBox(height: 16),

            const ActiveGoalSection(),

            const SizedBox(height: 24),

            Text(
              'Quick Actions',

              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const QuickActionsRow(),

            const SizedBox(height: 24),

            Text(
              "Today's Calories",

              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const TodayCaloriesSection(),
          ],
        ),
      ),
    );
  }
}
