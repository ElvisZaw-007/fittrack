// lib/core/router/app_routes.dart

abstract final class AppRoutes {
  static const String authGate = '/'; // ← ADD THIS
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String goals = '/goals';
  static const String goalHistory = '/goal-history';
  static const String weightLogs = '/weight-logs';
  static const String workouts = '/workouts';
  static const String meals = '/meals';
  static const String progress = '/progress';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
}
