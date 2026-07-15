// lib/features/auth/data/repositories/supabase_auth_repository.dart

import 'dart:io';

import 'package:fittrack/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:fittrack/features/auth/domain/entities/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/auth/domain/entities/app_user.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const SupabaseAuthRepository(this._remoteDataSource);

  // Maps Supabase's User to your domain entity.
  // This is the only place in the entire codebase that knows
  // how Supabase represents a user.

  @override
  AppUser? get currentUser {
    final userModel = _remoteDataSource.getCurrentUser();
    if (userModel == null) return null;
    return AppUser(id: userModel.id, email: userModel.email);
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges().map((event) {
      debugPrint(
        'AUTH EVENT => ${event.event} USER => ${event.session?.user.email}',
      );
      final user = event.session?.user;
      if (user == null) {
        return null;
      }
      return AppUser(id: user.id, email: user.email ?? '');
    });
  }

  @override
  Stream<AuthStatus> get authStatusChanges {
    return _remoteDataSource.authStateChanges().map((event) {
      switch (event.event) {
        case AuthChangeEvent.passwordRecovery:
          return AuthStatus.passwordRecovery;

        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          return AuthStatus.authenticated;

        case AuthChangeEvent.signedOut:
          return AuthStatus.unauthenticated;

        default:
          return _remoteDataSource.getCurrentUser() != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated;
      }
    });
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUp(
        email: email,
        password: password,
      );
      return AppUser(id: userModel.id, email: userModel.email);
    } on AuthException catch (e, stackTrace) {
      debugPrint('====== AUTH ERROR ======');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('CODE: ${e.code}');
      debugPrint('STATUS: ${e.statusCode}');
      debugPrint(stackTrace.toString());
      throw _mapAuthException(e);
    } on SocketException {
      throw const NetworkFailure();
    } catch (e, stackTrace) {
      print("REGISTER ERROR => $e");
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    //debugPrint('LOGIN REPOSITORY CALLED');
    try {
      final userModel = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      // debugPrint('LOGIN SUCCESS => ${user.email}');
      return AppUser(id: userModel.id, email: userModel.email);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } on SocketException {
      throw const NetworkFailure();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.signOut();
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  // Translates Supabase error codes into typed domain failures.
  // The domain layer never sees an AuthException.
  Failure _mapAuthException(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return const InvalidCredentialsFailure();
      case 'email_address_invalid':
        return const InvalidEmailFailure();
      case 'user_already_exists':
      case 'email_exists':
        return const EmailAlreadyInUseFailure();
      case 'weak_password':
        return const WeakPasswordFailure();
      default:
        return ServerFailure(e.message);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } on SocketException {
      throw const NetworkFailure();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    try {
      await _remoteDataSource.resetPassword(newPassword: newPassword);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } on SocketException {
      throw const NetworkFailure();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
