// lib/core/router/app_router.dart

import 'package:fittrack/core/router/app_routes.dart';
import 'package:fittrack/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:fittrack/features/auth/presentation/pages/login_page.dart';
import 'package:fittrack/features/auth/presentation/pages/register_page.dart';
import 'package:fittrack/features/auth/presentation/pages/reset_password_page.dart';
import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fittrack/features/goals/presentation/pages/create_goal_screen.dart';
import 'package:fittrack/features/meals/presentation/pages/meals_page.dart';
import 'package:fittrack/features/profile/presentation/pages/profile_page.dart';
import 'package:fittrack/features/progress/presentation/pages/progress_page.dart';
import 'package:fittrack/features/weight_logs/presentation/pages/weight_log_page.dart';
import 'package:fittrack/features/workouts/presentation/pages/workouts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Watch auth state — router rebuilds when auth changes.
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.value != null;

  return GoRouter(
    initialLocation: AppRoutes.login,

    redirect: (context, state) {
      debugPrint('----------------');
      debugPrint('Location: ${state.uri}');
      debugPrint('Matched: ${state.matchedLocation}');
      debugPrint('Authenticated: $isAuthenticated');

      final isOnAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.resetPassword;

      if (!isAuthenticated && !isOnAuthRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated &&
          (state.matchedLocation == AppRoutes.login ||
              state.matchedLocation == AppRoutes.register)) {
        return AppRoutes.dashboard;
      }

      return null;
    },

    routes: [
      // -------------------------
      // Authentication
      // -------------------------
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // -------------------------
      // Dashboard
      // -------------------------
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),

      // -------------------------
      // Profile
      // -------------------------
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),

      // -------------------------
      // Goals
      // -------------------------
      GoRoute(
        path: AppRoutes.goals,
        builder: (context, state) => const CreateGoalScreen(),
      ),

      GoRoute(
        path: AppRoutes.goalHistory,
        builder: (context, state) => const CreateGoalScreen(),
      ),

      // -------------------------
      // Weight Logs
      // -------------------------
      GoRoute(
        path: AppRoutes.weightLogs,
        builder: (context, state) => const WeightLogPage(),
      ),

      // -------------------------
      // Workouts
      // -------------------------
      GoRoute(
        path: AppRoutes.workouts,
        builder: (context, state) => const WorkoutsPage(),
      ),

      // -------------------------
      // Meals
      // -------------------------
      GoRoute(
        path: AppRoutes.meals,
        builder: (context, state) => const MealsPage(),
      ),

      // -------------------------
      // Progress
      // -------------------------
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
    ],
  );
}
