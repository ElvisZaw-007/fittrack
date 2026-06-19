// lib/features/profile/presentation/providers/profile_notifier.dart

import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fittrack/features/profile/data/providers/profile_providers.dart';
import 'package:fittrack/features/profile/domain/entities/profile.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Profile?> build() async {
    final user = await ref.watch(authStateProvider.future);
    if (user == null) {
      //No authenticated user - nothing to fetch.
      //This is a valid state, not an error.
      return null;
    }
    return ref.read(getProfileUseCaseProvider)();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authStateProvider.future);
      if (user == null) return null;
      return await ref.read(getProfileUseCaseProvider)();
    });
  }
}

@riverpod
class SaveProfileNotifier extends _$SaveProfileNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> save(Profile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
    () async {
      await ref.read(saveProfileUseCaseProvider)(profile);
    },
  );   

    // After a successful save, refresh the displayed profile
    if (!state.hasError) {
      ref.invalidate(profileProvider);
    }
  }
}
