import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_notifier.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  @override
  void initState() {
    super.initState();

    final uri = Uri.base;

    final isRecoveryLink =
        uri.path == '/reset-password' &&
        uri.queryParameters.containsKey('code');

    // Recovery flow ကို AuthGate က interfere မလုပ်စေချင်ဘူး
    if (isRecoveryLink) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/reset-password');
        }
      });
      return;
    }

    ref.listenManual(authStateProvider, (_, next) {
      next.whenData((user) {
        if (!mounted) return;

        if (user != null) {
          context.go('/dashboard');
        } else {
          context.go('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
