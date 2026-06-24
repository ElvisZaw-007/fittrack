import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';

class DeleteWeightLogUseCase {
  final WeightLogRepository _repository;
  const DeleteWeightLogUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteWeightLog(id);
}
