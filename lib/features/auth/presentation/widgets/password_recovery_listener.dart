// lib/features/auth/presentation/widgets/password_recovery_listener.dart

import 'package:fittrack/core/router/app_routes.dart';
import 'package:fittrack/features/auth/presentation/providers/password_recovery_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PasswordRecoveryListener extends ConsumerWidget {
  final Widget child;

  const PasswordRecoveryListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(passwordRecoveryProvider, (_, next) {
      next.whenData((isRecovery) {
        if (isRecovery) {
          context.go(AppRoutes.resetPassword);
        }
      });
    });

    return child;
  }
}
