// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fittrack/core/hive/hive_service.dart';
import 'package:fittrack/core/router/app_router.dart';
import 'package:fittrack/core/services/service_providers.dart';

/// Exchange recovery code for session before app renders.
/// Must be called immediately after Supabase.initialize().

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await HiveService.init();

  // Environment Variables
  await dotenv.load(fileName: '.env');

  // Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Handle recovery/password reset link BEFORE runApp

  runApp(const ProviderScope(child: FitTrackApp()));
}

class FitTrackApp extends ConsumerStatefulWidget {
  const FitTrackApp({super.key});

  @override
  ConsumerState<FitTrackApp> createState() => _FitTrackAppState();
}

class _FitTrackAppState extends ConsumerState<FitTrackApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Deep link service handles OTHER deep links (not recovery)
      // Recovery is already handled in main() before app starts
      ref.read(deepLinkServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FitTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
