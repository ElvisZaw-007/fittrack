import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';
import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';

class UpdateMealUseCase {
  final MealRepository _repository;
  const UpdateMealUseCase(this._repository);

  Future<void> call(MealEntity meal) {
    return _repository.updateMeal(meal);
  }
}
