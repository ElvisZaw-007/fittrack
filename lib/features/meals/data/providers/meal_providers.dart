import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource.dart';
import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource_impl.dart';
import 'package:fittrack/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';
import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';
import 'package:fittrack/features/meals/domain/usecases/add_meal_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/get_meals_usecase.dart';
import 'package:fittrack/features/meals/domain/usecases/get_today_calories_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final mealRemoteDataSourceProvider = Provider<MealRemoteDatasource>((ref) {
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

final getTodayCaloriesUseCaseProvider = Provider<GetTodayCaloriesUsecase>((
  ref,
) {
  return GetTodayCaloriesUsecase(ref.read(mealRepositoryProvider));
});

// Future Providers
final mealsProvider = FutureProvider<List<MealEntity>>((ref) async {
  return ref.read(getMealsUseCaseProvider)();
});

final todayCaloriesProvider = FutureProvider<int>((ref) async {
  return ref.read(getTodayCaloriesUseCaseProvider)();
});
