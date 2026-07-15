// lib/features/auth/presentation/providers/password_recovery_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final passwordRecoveryProvider = StreamProvider<bool>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.event == AuthChangeEvent.passwordRecovery,
  );
});
