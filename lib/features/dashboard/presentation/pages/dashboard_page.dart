// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fittrack/core/router/app_routes.dart';
import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/auth/data/providers/auth_providers.dart';
import 'package:fittrack/features/goals/presentation/providers/goal_notifiers.dart';
import 'package:fittrack/features/weight_logs/presentation/providers/weight_log_notifiers.dart';

import 'package:fittrack/features/goals/presentation/widgets/active_goal_section.dart';
import 'package:fittrack/features/weight_logs/presentation/widgets/weight_summary_section.dart';
import 'package:fittrack/features/dashboard/presentation/widgets/quick_actions_row.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userName = authState.asData?.value?.email ?? 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(logoutUseCaseProvider)(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(latestWeightProvider);
          ref.invalidate(activeGoalProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Hello, $userName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Each section is independent — one failing does not block others
            const WeightSummarySection(),
            const SizedBox(height: 16),
            const ActiveGoalSection(),
            const SizedBox(height: 16),
            const QuickActionsRow(),
          ],
        ),
      ),
    );
  }
}
