// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_notifiers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveGoalNotifier)
final activeGoalProvider = ActiveGoalNotifierProvider._();

final class ActiveGoalNotifierProvider
    extends $AsyncNotifierProvider<ActiveGoalNotifier, Goal?> {
  ActiveGoalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeGoalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeGoalNotifierHash();

  @$internal
  @override
  ActiveGoalNotifier create() => ActiveGoalNotifier();
}

String _$activeGoalNotifierHash() =>
    r'e717b56edff6834708edc4132e746f5bb768b97d';

abstract class _$ActiveGoalNotifier extends $AsyncNotifier<Goal?> {
  FutureOr<Goal?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Goal?>, Goal?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Goal?>, Goal?>,
              AsyncValue<Goal?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(GoalHistoryNotifier)
final goalHistoryProvider = GoalHistoryNotifierProvider._();

final class GoalHistoryNotifierProvider
    extends $AsyncNotifierProvider<GoalHistoryNotifier, List<Goal>> {
  GoalHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalHistoryNotifierHash();

  @$internal
  @override
  GoalHistoryNotifier create() => GoalHistoryNotifier();
}

String _$goalHistoryNotifierHash() =>
    r'd59fd92393ce0013429db293ffa1f9f65a41b5e2';

abstract class _$GoalHistoryNotifier extends $AsyncNotifier<List<Goal>> {
  FutureOr<List<Goal>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Goal>>, List<Goal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Goal>>, List<Goal>>,
              AsyncValue<List<Goal>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(GoalActionNotifier)
final goalActionProvider = GoalActionNotifierProvider._();

final class GoalActionNotifierProvider
    extends $NotifierProvider<GoalActionNotifier, AsyncValue<void>> {
  GoalActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalActionNotifierHash();

  @$internal
  @override
  GoalActionNotifier create() => GoalActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$goalActionNotifierHash() =>
    r'1dbeb28bc6a919766f66236efe93579f3a720891';

abstract class _$GoalActionNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
