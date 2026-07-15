import 'package:fittrack/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:fittrack/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;
  AuthRemoteDataSourceImpl(this._supabase);

  @override
  Future<AppUserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('REGISTER METHOD CALLED IN DATA SOURCE');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      debugPrint('USER => ${response.user?.email}');
      debugPrint('SESSION => ${response.session}');
      debugPrint('CURRENT USER => ${_supabase.auth.currentUser?.email}');

      final user = response.user;

      if (user == null) {
        throw Exception('No user returned');
      }

      return AppUserModel.fromUser(user);
    } on AuthException catch (e) {
      debugPrint('AUTH EXCEPTION MESSAGE => ${e.message}');
      debugPrint('AUTH EXCEPTION CODE => ${e.code}');
      rethrow;
    } catch (e, st) {
      debugPrint('UNKNOWN ERROR => $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('DATASOURCE LOGIN START');

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      debugPrint('LOGIN USER => ${response.user?.email}');
      debugPrint('LOGIN SESSION => ${response.session}');
      debugPrint('CURRENT USER => ${_supabase.auth.currentUser?.email}');

      final user = response.user;

      if (user == null) {
        throw Exception('No user returned');
      }

      return AppUserModel.fromUser(user);
    } on AuthException catch (e) {
      debugPrint('LOGIN AUTH EXCEPTION => ${e.message}');
      debugPrint('LOGIN AUTH CODE => ${e.code}');
      rethrow;
    } catch (e, st) {
      debugPrint('LOGIN UNKNOWN ERROR => $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'http://localhost:3000/reset-password',
      );

      debugPrint('PASSWORD RESET EMAIL SENT => $email');
    } on AuthException catch (e) {
      debugPrint('FORGOT PASSWORD ERROR => ${e.message}');
      debugPrint('FORGOT PASSWORD CODE => ${e.code}');
      rethrow;
    } catch (e, st) {
      debugPrint('FORGOT PASSWORD UNKNOWN ERROR => $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      debugPrint('PASSWORD UPDATED SUCCESSFULLY');
    } on AuthException catch (e) {
      debugPrint('RESET PASSWORD ERROR => ${e.message}');
      debugPrint('RESET PASSWORD CODE => ${e.code}');
      rethrow;
    } catch (e, st) {
      debugPrint('RESET PASSWORD UNKNOWN ERROR => $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  @override
  AppUserModel? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return AppUserModel.fromUser(user);
  }
}
