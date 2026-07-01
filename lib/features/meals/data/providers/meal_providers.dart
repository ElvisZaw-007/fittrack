import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource.dart';
import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource_impl.dart';
import 'package:fittrack/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';
import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';
import 'package:fittrack/features/meals/domain/usecases/add_meal_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/delete_meal_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/get_meals_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/get_today_calories_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/update_meal_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'meal_providers.g.dart';

final mealRemoteDataSourceProvider = Provider<MealRemoteDataSource>((ref) {
  return MealRemoteDataSourceImpl(Supabase.instance.client);
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(ref.read(mealRemoteDataSourceProvider));
});

final getMealsUseCaseProvider = Provider<GetMealsUseCase>((ref) {
  return GetMealsUseCase(ref.read(mealRepositoryProvider));
});

final addMealUseCaseProvider = Provider<AddMealUseCase>((ref) {
  return AddMealUseCase(ref.read(mealRepositoryProvider));
});

final getTodayCaloriesUseCaseProvider = Provider<GetTodayCaloriesUseCase>((
  ref,
) {
  return GetTodayCaloriesUseCase(ref.read(mealRepositoryProvider));
});

final updateMealUsecaseProvider = Provider<UpdateMealUseCase>((ref) {
  return UpdateMealUseCase(ref.read(mealRepositoryProvider));
});

final deleteMealUsecaseProvider = Provider<DeleteMealUseCase>((ref) {
  return DeleteMealUseCase(ref.read(mealRepositoryProvider));
});

final mealsProvider = FutureProvider<List<MealEntity>>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return [];
  return ref.read(getMealsUseCaseProvider)();
});

final todayCaloriesProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return 0;
  return ref.read(getTodayCaloriesUseCaseProvider)();
});

@riverpod
class MealNotifier extends _$MealNotifier {
  @override
  Future<List<MealEntity>> build() async {
    final user = await ref.watch(authStateProvider.future);
    if (user == null) {
      return [];
    }
    return ref.read(getMealsUseCaseProvider)();
  }
}
