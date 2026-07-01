// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MealNotifier)
final mealProvider = MealNotifierProvider._();

final class MealNotifierProvider
    extends $AsyncNotifierProvider<MealNotifier, List<MealEntity>> {
  MealNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealNotifierHash();

  @$internal
  @override
  MealNotifier create() => MealNotifier();
}

String _$mealNotifierHash() => r'4eea316f1784be68e540a160982f2b569cfed1b0';

abstract class _$MealNotifier extends $AsyncNotifier<List<MealEntity>> {
  FutureOr<List<MealEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MealEntity>>, List<MealEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MealEntity>>, List<MealEntity>>,
              AsyncValue<List<MealEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
