// lib/features/auth/presentation/providers/auth_notifier.dart

import 'package:fittrack/features/auth/data/providers/auth_providers.dart';
import 'package:fittrack/features/auth/domain/entities/app_user.dart';
import 'package:fittrack/features/auth/domain/entities/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

// Watches auth state changes — the single source of truth for
// whether the user is logged in. GoRouter listens to this.
@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@Riverpod(keepAlive: true)
Stream<AuthStatus> authStatus(Ref ref) {
  return ref.watch(authRepositoryProvider).authStatusChanges;
}

// Handles login action and its loading/error states
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> login({required String email, required String password}) async {
    debugPrint('LOGIN BUTTON PRESSED');
    state = const AsyncLoading();
    final useCase = ref.read(loginUseCaseProvider);

    state = await AsyncValue.guard(
      () => useCase(email: email, password: password),
    );
  }
}

// Handles register action and its loading/error states
@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(registerUseCaseProvider);
    state = await AsyncValue.guard(
      () => useCase(email: email, password: password),
    );
  }
}

@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> sendResetEmail({required String email}) async {
    state = const AsyncLoading();

    final useCase = ref.read(forgotPasswordUseCaseProvider);

    state = await AsyncValue.guard(() => useCase(email: email));
  }
}

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> resetPassword({required String newPassword}) async {
    state = const AsyncLoading();

    final useCase = ref.read(resetPasswordUseCaseProvider);

    state = await AsyncValue.guard(() => useCase(newPassword: newPassword));
  }
}
