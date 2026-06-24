// lib/features/weight_logs/presentation/providers/weight_log_notifiers.dart

import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/weight_logs/data/providers/weight_log_providers.dart';
import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weight_log_notifiers.g.dart';

// Dashboard watches this — latest single entry
@riverpod
class LatestWeightNotifier extends _$LatestWeightNotifier {
  @override
  Future<WeightLog?> build() async {
    final user = await ref.watch(authStateProvider.future);
    if (user == null) return null;
    return ref.read(getLatestWeightUseCaseProvider)();
  }
}

// Progress screen watches this — full history
@riverpod
class WeightHistoryNotifier extends _$WeightHistoryNotifier {
  @override
  Future<List<WeightLog>> build() async {
    final user = await ref.watch(authStateProvider.future);
    if (user == null) return [];
    return ref.read(getWeightHistoryUseCaseProvider)();
  }
}

// All mutations go here — same pattern as GoalActionNotifier
@riverpod
class WeightLogActionNotifier extends _$WeightLogActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> addLog(WeightLog log) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(addWeightLogUseCaseProvider)(log),
    );
    _refresh();
  }

  Future<void> updateLog(WeightLog log) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(updateWeightLogUseCaseProvider)(log),
    );
    _refresh();
  }

  Future<void> deleteLog(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deleteWeightLogUseCaseProvider)(id),
    );
    _refresh();
  }

  void _refresh() {
    if (!state.hasError) {
      // Both consumers update — dashboard and progress screen stay in sync
      ref.invalidate(latestWeightProvider);
      ref.invalidate(weightHistoryProvider);
    }
  }
}