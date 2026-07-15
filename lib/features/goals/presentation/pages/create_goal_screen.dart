// lib/features/goals/presentation/pages/create_goal_screen.dart

import 'package:fittrack/features/goals/domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_routes.dart';
import 'package:fittrack/core/widgets/loading_view.dart';
import 'package:fittrack/core/widgets/error_view.dart';
import 'package:fittrack/core/widgets/empty_state_view.dart';
import '../providers/goal_notifiers.dart';
import '../widgets/active_goal_card.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  @override
  void initState() {
    super.initState();
    _listenToGoalActions();
  }

  void _listenToGoalActions() {
    ref.listen<AsyncValue<void>>(goalActionProvider, (previous, next) {
      if (!mounted) return;

      next.whenOrNull(
        error: (error, _) => _showErrorSnackBar(_mapErrorToMessage(error)),
        data: (_) {
          if (previous?.isLoading == true) {
            _showSnackBar('Operation completed successfully!');
          }
        },
      );
    });
  }

  String _mapErrorToMessage(Object error) {
    return switch (error) {
      GoalAlreadyActiveFailure() => error.message,
      InvalidGoalFailure() => error.message,
      InvalidGoalDateFailure() => error.message,
      ServerFailure() => error.message,
      _ => 'Operation failed',
    };
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorSnackBar(String message) {
    _showSnackBar(message);
  }

  void _handleCreateGoal() {
    // Navigate to dedicated creation flow or scroll to form
    // Adjust based on your actual UX — this is a placeholder
  }

  @override
  Widget build(BuildContext context) {
    final activeGoalAsync = ref.watch(activeGoalProvider);
    final isMutating = ref.watch(goalActionProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.goalHistory),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: activeGoalAsync.when(
          data: (activeGoal) => activeGoal != null
              ? _ActiveGoalView(goal: activeGoal, isMutating: isMutating)
              : EmptyStateView(
                  icon: Icons.flag_outlined,
                  title: 'No active goal',
                  message:
                      'Set your first goal and start your fitness journey.',
                  actionLabel: 'Create Goal',
                  onAction: _handleCreateGoal,
                ),
          loading: () => const LoadingView(message: 'Loading your goal...'),
          error: (error, stackTrace) => ErrorView(
            message: 'Unable to load your goal.',
            onRetry: () => ref.invalidate(activeGoalProvider),
          ),
        ),
      ),
    );
  }
}

class _ActiveGoalView extends ConsumerWidget {
  final Goal goal;
  final bool isMutating;

  const _ActiveGoalView({required this.goal, required this.isMutating});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ActiveGoalCard(
          goal: goal,
          currentWeight: goal.startWeight,
          onComplete: () {
            final id = goal.id;
            if (id == null) return;
            ref.read(goalActionProvider.notifier).completeGoal(id);
          },
          onAbandon: () {
            final id = goal.id;
            if (id == null) return;
            ref.read(goalActionProvider.notifier).abandonGoal(id);
          },
        ),
        if (isMutating)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
