// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:fittrack/features/auth/domain/entities/auth_status.dart';

import '../entities/app_user.dart';

abstract interface class AuthRepository {
  /// Returns the currently authenticated user, or null if unauthenticated.
  AppUser? get currentUser;

  /// Stream that emits the current user whenever auth state changes.
  Stream<AppUser?> get authStateChanges;
  Stream<AuthStatus> get authStatusChanges;

  /// Creates a new account. Returns the created [AppUser].
  /// Throws [EmailAlreadyInUseFailure] if the email is taken.
  Future<AppUser> register({required String email, required String password});

  /// Signs in an existing user. Returns the authenticated [AppUser].
  /// Throws [InvalidCredentialsFailure] if credentials are wrong.
  Future<AppUser> login({required String email, required String password});

  /// Signs out the current user.
  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({required String newPassword});
}
