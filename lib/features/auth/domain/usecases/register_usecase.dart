// lib/features/auth/domain/usecases/register_usecase.dart

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/auth/domain/entities/app_user.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<AppUser> call({
    required String email,
    required String password,
  }) async {
    // Business rule 1: validate email format
    if (!_isValidEmail(email)) {
      throw const InvalidEmailFailure();
    }

    // Business rule 2: enforce password strength
    if (password.length < 8) {
      throw const WeakPasswordFailure();
    }

    // Delegate to repository — use case does not know HOW registration works
    return _repository.register(email: email.trim(), password: password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
