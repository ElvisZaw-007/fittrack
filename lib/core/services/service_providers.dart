// lib/core/services/service_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fittrack/core/router/app_router.dart';
import 'package:fittrack/core/services/deep_link_service.dart';
import 'package:fittrack/features/auth/data/providers/auth_providers.dart';

part 'service_providers.g.dart';

@riverpod
DeepLinkService deepLinkService(Ref ref) {
  return DeepLinkService(
    router: ref.watch(appRouterProvider),
    supabase: ref.watch(supabaseClientProvider),
  );
}
