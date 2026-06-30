import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';

class GetTodayCaloriesUseCase {
  final MealRepository _repository;
  const GetTodayCaloriesUseCase(this._repository);
  Future<int> call() {
    return _repository.getTodayCalories();
  }
}
