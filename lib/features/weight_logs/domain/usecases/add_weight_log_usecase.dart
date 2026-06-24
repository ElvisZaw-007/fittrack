import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';

import '../../../../core/errors/failures.dart';

class AddWeightLogUseCase {
  final WeightLogRepository _repository;
  const AddWeightLogUseCase(this._repository);

  Future<WeightLog> call(WeightLog log) async {
    if (log.weightKg <= 0 || log.weightKg > 500) {
      throw const InvalidWeightLogFailure(
        'Weight must be between 0 and 500kg.',
      );
    }
    //logggedAt must not be in the future
    if (log.loggedAt.isAfter(DateTime.now())) {
      throw const InvalidWeightLogFailure('log data cannot be in the future.');
    }
    return _repository.addWeightLog(log);
  }
}
