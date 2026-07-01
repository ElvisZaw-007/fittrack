import '../entities/meal_entity.dart';

abstract interface class MealRepository {
  Future<List<MealEntity>> getMeals();
  Future<void> addMeal(MealEntity meal);
  Future<int> getTodayCalories();
  Future<void> updateMeal(MealEntity meal);
  Future<void> deleteMeal(String mealId);
}
