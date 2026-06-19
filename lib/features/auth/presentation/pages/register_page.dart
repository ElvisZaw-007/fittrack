// lib/features/auth/presentation/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/core/router/app_routes.dart';
import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';

import '../../data/providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    ref.listenManual<AsyncValue<void>>(registerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully. Please Login'),
            ),
          );

          //Check the log
          debugPrint('Register Success');
          final authRepo = ref.read(authRepositoryProvider);

          debugPrint('CURRENT USER = ${authRepo.currentUser?.email}');
          debugPrint('Current Rote -> profile');
          context.go(AppRoutes.profile);
        },
        error: (error, stackTrace) {
          debugPrint('REGISTER ERROR => $error');

          if (error is ServerFailure) {
            debugPrint('Server Message => ${error.message}');
          }
          debugPrintStack(stackTrace: stackTrace);

          final message = switch (error) {
            EmailAlreadyInUseFailure() =>
              'An account with this email already exists.',

            WeakPasswordFailure() => 'Password must be at least 8 characters.',

            InvalidEmailFailure() => 'Please enter a valid email address.',

            NetworkFailure() => 'No internet connection.',

            _ => 'Something went wrong. Please try again.',
          };

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref
        .read(registerProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: registerState.isLoading ? null : _register,
                  child: registerState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
