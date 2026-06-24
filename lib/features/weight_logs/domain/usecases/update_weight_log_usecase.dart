import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';

class UpdateWeightLogUseCase {
  final WeightLogRepository _repository;
  const UpdateWeightLogUseCase(this._repository);

  Future<WeightLog> call(WeightLog log) async {
    if (log.id == null) {
      throw const InvalidWeightLogFailure('Cannot Update a log with an id. ');
    }

    if (log.weightKg <= 0 || log.weightKg > 500) {
      throw const InvalidWeightLogFailure(
        'Weight must be between 0 and 500 kg.',
      );
    }
    return _repository.updateWeightLog(log);
  }
}
