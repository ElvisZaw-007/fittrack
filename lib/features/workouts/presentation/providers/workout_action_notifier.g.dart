// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_action_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutActionNotifier)
final workoutActionProvider = WorkoutActionNotifierProvider._();

final class WorkoutActionNotifierProvider
    extends $AsyncNotifierProvider<WorkoutActionNotifier, void> {
  WorkoutActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutActionNotifierHash();

  @$internal
  @override
  WorkoutActionNotifier create() => WorkoutActionNotifier();
}

String _$workoutActionNotifierHash() =>
    r'2eb422773dc7749135e0ccc6e6c7d36dcb00f89b';

abstract class _$WorkoutActionNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
