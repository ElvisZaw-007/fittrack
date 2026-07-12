import 'package:fittrack/features/meals/data/models/meal_model.dart';

abstract interface class MealLocalDataSource {
  Future<List<MealModel>> getCachedMeals();
  Future<void> cacheMeals(List<MealModel> meals);
  Future<void> clearCache();
}
