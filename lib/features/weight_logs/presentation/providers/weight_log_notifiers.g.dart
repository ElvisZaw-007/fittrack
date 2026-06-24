// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_log_notifiers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LatestWeightNotifier)
final latestWeightProvider = LatestWeightNotifierProvider._();

final class LatestWeightNotifierProvider
    extends $AsyncNotifierProvider<LatestWeightNotifier, WeightLog?> {
  LatestWeightNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestWeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestWeightNotifierHash();

  @$internal
  @override
  LatestWeightNotifier create() => LatestWeightNotifier();
}

String _$latestWeightNotifierHash() =>
    r'95ec5585e84c99952714bb91659f1f56d0a1db8b';

abstract class _$LatestWeightNotifier extends $AsyncNotifier<WeightLog?> {
  FutureOr<WeightLog?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WeightLog?>, WeightLog?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WeightLog?>, WeightLog?>,
              AsyncValue<WeightLog?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(WeightHistoryNotifier)
final weightHistoryProvider = WeightHistoryNotifierProvider._();

final class WeightHistoryNotifierProvider
    extends $AsyncNotifierProvider<WeightHistoryNotifier, List<WeightLog>> {
  WeightHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightHistoryNotifierHash();

  @$internal
  @override
  WeightHistoryNotifier create() => WeightHistoryNotifier();
}

String _$weightHistoryNotifierHash() =>
    r'37a02881a386884edad15eb07c8f9b5aa4d6c2b9';

abstract class _$WeightHistoryNotifier extends $AsyncNotifier<List<WeightLog>> {
  FutureOr<List<WeightLog>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<WeightLog>>, List<WeightLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WeightLog>>, List<WeightLog>>,
              AsyncValue<List<WeightLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(WeightLogActionNotifier)
final weightLogActionProvider = WeightLogActionNotifierProvider._();

final class WeightLogActionNotifierProvider
    extends $NotifierProvider<WeightLogActionNotifier, AsyncValue<void>> {
  WeightLogActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightLogActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightLogActionNotifierHash();

  @$internal
  @override
  WeightLogActionNotifier create() => WeightLogActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$weightLogActionNotifierHash() =>
    r'54156e621aea0a503bcb0d9eb4a71943d26e6329';

abstract class _$WeightLogActionNotifier extends $Notifier<AsyncValue<void>> {
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
