// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutsNotifier)
final workoutsProvider = WorkoutsNotifierProvider._();

final class WorkoutsNotifierProvider
    extends $AsyncNotifierProvider<WorkoutsNotifier, List<WorkoutEntity>> {
  WorkoutsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutsNotifierHash();

  @$internal
  @override
  WorkoutsNotifier create() => WorkoutsNotifier();
}

String _$workoutsNotifierHash() => r'491787524ba42a055297a080bb9f4558ddbab6ab';

abstract class _$WorkoutsNotifier extends $AsyncNotifier<List<WorkoutEntity>> {
  FutureOr<List<WorkoutEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WorkoutEntity>>, List<WorkoutEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WorkoutEntity>>, List<WorkoutEntity>>,
              AsyncValue<List<WorkoutEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
