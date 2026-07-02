// lib/core/router/app_router.dart
import 'package:fittrack/features/meals/presentation/pages/meals_page.dart';
import 'package:fittrack/features/progress/presentation/pages/progress_page.dart';
import 'package:fittrack/features/workouts/presentation/pages/workouts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fittrack/features/auth/presentation/pages/login_page.dart';
import 'package:fittrack/features/auth/presentation/pages/register_page.dart';
import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/core/router/app_routes.dart';

import '../../features/goals/presentation/pages/create_goal_screen.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/weight_logs/presentation/pages/weight_log_page.dart';

part 'app_router.g.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Dashboard')));
}

@riverpod
GoRouter appRouter(Ref ref) {
  // Watch auth state — router rebuilds when auth changes
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.value != null;

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isOnAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Unauthenticated user trying to access protected route
      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;

      // Authenticated user trying to access auth routes
      if (isAuthenticated && isOnAuthRoute) return AppRoutes.dashboard;

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.goals,
        builder: (context, state) => const CreateGoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.goalHistory,
        builder: (context, state) => const CreateGoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.weightLogs,
        builder: (context, state) => const WeightLogPage(),
      ),
      GoRoute(
        path: AppRoutes.workouts,
        builder: (_, _) => const WorkoutsPage(),
      ),
      GoRoute(
        path: AppRoutes.meals,
        builder: (context, state) => const MealsPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressPage(),
      ),
    ],
  );
}
