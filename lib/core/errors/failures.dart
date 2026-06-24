// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Auth failures
class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Please enter a valid email address.');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure()
    : super('Password must be at least 8 characters.');
}

class EmptyPasswordFailure extends Failure {
  const EmptyPasswordFailure() : super('Password cannot be empty');
}

class EmptyCredentialsFailure extends Failure {
  const EmptyCredentialsFailure()
    : super('Email and password cannot be empty.');
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Incorrect email or password.');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
    : super('An account with this email already exists.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('No account found with this email.');
}

// Network and infrastructure failures
class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('No internet connection. Please check your network.');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Failed to read local data.');
}

// Goal failures — already discussed
class GoalAlreadyActiveFailure extends Failure {
  const GoalAlreadyActiveFailure()
    : super('You already have an active goal. Complete or abandon it first.');
}

class InvalidGoalDateFailure extends Failure {
  const InvalidGoalDateFailure() : super('Target date must be in the future.');
}

class InvalidProfileFailure extends Failure {
  const InvalidProfileFailure(super.message);
}

class InvalidGoalFailure extends Failure {
  const InvalidGoalFailure(super.message);
}

class WeightLostNotFound extends Failure {
  const WeightLostNotFound() : super('Weight Log not found');
}

class DuplicateWeightLogFailure extends Failure {
  const DuplicateWeightLogFailure()
    : super('A weight entry for today already exists.');
}

class InvalidWeightLogFailure extends Failure {
  const InvalidWeightLogFailure(super.message);// : super('Weight format is Wrong');
}
