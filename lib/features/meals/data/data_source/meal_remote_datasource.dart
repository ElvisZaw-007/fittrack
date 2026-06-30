import 'package:fittrack/features/meals/data/models/meal_model.dart';

abstract interface class MealRemoteDataSource {
  Future<List<MealModel>> getMeals();
  Future<void> addMeal(MealModel meal);
  Future<int> getTodayCalories();
}
