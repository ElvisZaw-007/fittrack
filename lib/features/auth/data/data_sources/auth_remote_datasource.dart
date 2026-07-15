import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AppUserModel> signUp({
    required String email,
    required String password,
  });
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({required String newPassword});

  Stream<AuthState> authStateChanges();

  AppUserModel? getCurrentUser();
}
