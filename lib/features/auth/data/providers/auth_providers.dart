// lib/features/auth/data/providers/auth_providers.dart

import 'package:fittrack/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:fittrack/features/auth/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fittrack/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:fittrack/features/auth/domain/usecases/login_usecase.dart';
import 'package:fittrack/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fittrack/features/auth/domain/usecases/register_usecase.dart';
import 'package:fittrack/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fittrack/features/auth/domain/usecases/reset_password_usecase.dart';

part 'auth_providers.g.dart';

// The Supabase client — single instance, shared across all repositories
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}

// Repository — typed as the interface, implemented by Supabase
@riverpod
AuthRepository authRepository(Ref ref) {
  return SupabaseAuthRepository(ref.watch(authRemoteDataSourceProvider));
}

// Use cases — each receives the repository interface
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
}
