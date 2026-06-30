import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';

class GetTodayCaloriesUsecase {
  final MealRepository _repository;
  const GetTodayCaloriesUsecase(this._repository);
  Future<int> call() {
    return _repository.getTodayCalories();
  }
}
