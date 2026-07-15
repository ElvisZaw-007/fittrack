// lib/core/services/deep_link_service.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fittrack/core/router/app_routes.dart';

class DeepLinkService {
  final GoRouter _router;
  final SupabaseClient _supabase;

  DeepLinkService({required GoRouter router, required SupabaseClient supabase})
    : _router = router,
      _supabase = supabase;

  void initialize() {
    debugPrint('DEEP LINK SERVICE INITIALIZED');

    _supabase.auth.onAuthStateChange.listen((data) {
      debugPrint(
        'AUTH EVENT => ${data.event.name}'
        ' USER => ${data.session?.user.email}',
      );

      if (data.event == AuthChangeEvent.passwordRecovery) {
        debugPrint('PASSWORD RECOVERY DETECTED');

        _router.go(AppRoutes.resetPassword);
      }
    });
  }
}
