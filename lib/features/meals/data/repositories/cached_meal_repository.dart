import 'package:fittrack/core/errors/failures.dart';

import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';

import '../data_source/meal_local_datasource.dart';
import '../models/meal_model.dart';

class CachedMealRepository implements MealRepository {
  final MealRepository _remote;
  final MealLocalDataSource _local;

  const CachedMealRepository(this._remote, this._local);

  @override
  Future<List<MealEntity>> getMeals() async {
    try {
      final meals = await _remote.getMeals();

      await _local.cacheMeals(
        meals.map((meal) => MealModel.fromEntity(meal)).toList(),
      );

      return meals;
    } on NetworkFailure {
      final cached = await _local.getCachedMeals();

      if (cached.isEmpty) rethrow;

      return cached.map((meal) => meal.toEntity()).toList();
    }
  }

  @override
  Future<int> getTodayCalories() async {
    try {
      return await _remote.getTodayCalories();
    } on NetworkFailure {
      final cached = await _local.getCachedMeals();

      return cached.fold<int>(0, (total, meal) => total + meal.calories);
    }
  }

  @override
  Future<void> addMeal(MealEntity meal) async {
    await _remote.addMeal(meal);

    await _local.clearCache();
  }

  @override
  Future<void> updateMeal(MealEntity meal) async {
    await _remote.updateMeal(meal);

    await _local.clearCache();
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    await _remote.deleteMeal(mealId);

    await _local.clearCache();
  }
}
