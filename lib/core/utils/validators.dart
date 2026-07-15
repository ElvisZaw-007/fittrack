// lib/core/utils/validators.dart

/// Shared validation utilities for the entire app.
class Validators {
  const Validators._();

  /// Validates email format.
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  /// Validates password strength (minimum 8 characters).
  static bool isStrongPassword(String password) {
    return password.length >= 8;
  }
}
