// lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  Future<void> call({required String newPassword}) async {
    final password = newPassword.trim();

    // Business rule 1: password required
    if (password.isEmpty) {
      throw const EmptyPasswordFailure();
    }

    // Business rule 2: password strength
    if (password.length < 8) {
      throw const WeakPasswordFailure();
    }

    // Delegate to repository
    await _repository.resetPassword(newPassword: password);
  }
}
