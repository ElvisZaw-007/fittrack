// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/auth/domain/entities/app_user.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<AppUser> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty && password.isEmpty) {
      throw const EmptyCredentialsFailure();
    }

    if (email.isEmpty) {
      throw const InvalidEmailFailure();
    }

    if (password.isEmpty) {
      throw const EmptyPasswordFailure();
    }

    if (!_isValidEmail(email)) {
      throw const InvalidEmailFailure();
    }

    return _repository.login(email: email.trim(), password: password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
