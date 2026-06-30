import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';

import '../entities/meal_entity.dart';

class GetMealsUseCase {
  final MealRepository _repository;
  const GetMealsUseCase(this._repository);
  Future<List<MealEntity>> call() {
    return _repository.getMeals();
  }
}
