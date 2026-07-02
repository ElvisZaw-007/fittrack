// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_action_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MealsNotifier)
final mealsProvider = MealsNotifierProvider._();

final class MealsNotifierProvider
    extends $AsyncNotifierProvider<MealsNotifier, List<MealEntity>> {
  MealsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealsNotifierHash();

  @$internal
  @override
  MealsNotifier create() => MealsNotifier();
}

String _$mealsNotifierHash() => r'9cc85b5df5c95fea822015739c8119ecd00d1435';

abstract class _$MealsNotifier extends $AsyncNotifier<List<MealEntity>> {
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

@ProviderFor(TodayCaloriesNotifier)
final todayCaloriesProvider = TodayCaloriesNotifierProvider._();

final class TodayCaloriesNotifierProvider
    extends $AsyncNotifierProvider<TodayCaloriesNotifier, int> {
  TodayCaloriesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayCaloriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayCaloriesNotifierHash();

  @$internal
  @override
  TodayCaloriesNotifier create() => TodayCaloriesNotifier();
}

String _$todayCaloriesNotifierHash() =>
    r'7d94ca00108655b5408b2093435ffdeb060a9116';

abstract class _$TodayCaloriesNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MealActionNotifier)
final mealActionProvider = MealActionNotifierProvider._();

final class MealActionNotifierProvider
    extends $AsyncNotifierProvider<MealActionNotifier, void> {
  MealActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealActionNotifierHash();

  @$internal
  @override
  MealActionNotifier create() => MealActionNotifier();
}

String _$mealActionNotifierHash() =>
    r'a0693583b3ae983f9a0f5187cb15324a50789d11';

abstract class _$MealActionNotifier extends $AsyncNotifier<void> {
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
