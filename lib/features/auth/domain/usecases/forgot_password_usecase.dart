// lib/features/auth/domain/usecases/forgot_password_usecase.dart

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/core/utils/validators.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<void> call({required String email}) async {
    final normalizedEmail = email.trim();

    // Business rule 1: email required
    if (normalizedEmail.isEmpty) {
      throw const InvalidEmailFailure();
    }

    // Business rule 2: email format validation
    if (!Validators.isValidEmail(normalizedEmail)) {
      throw const InvalidEmailFailure();
    }

    // Delegate to repository
    await _repository.forgotPassword(email: normalizedEmail);
  }
}
