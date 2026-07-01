import 'package:fittrack/features/meals/domain/repositories/meal_repository.dart';

class DeleteMealUseCase {
  final MealRepository _repository;
  const DeleteMealUseCase(this._repository);

  Future<void> call(String mId) {
    return _repository.deleteMeal(mId);
  }
}
