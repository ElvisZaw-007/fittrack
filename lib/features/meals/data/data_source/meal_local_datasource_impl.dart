import 'dart:convert';

import 'package:fittrack/core/hive/hive_service.dart';
import 'package:hive/hive.dart';

import '../models/meal_model.dart';
import 'meal_local_datasource.dart';

class MealLocalDataSourceImpl implements MealLocalDataSource {
  static const _key = 'cached_meals';

  Box<String> get _box => HiveService.mealsBox;

  @override
  Future<List<MealModel>> getCachedMeals() async {
    final raw = _box.get(_key);

    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;

    return list
        .map((item) => MealModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheMeals(List<MealModel> meals) async {
    final json = jsonEncode(meals.map((meal) => meal.toJson()).toList());

    await _box.put(_key, json);
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_key);
  }
}
