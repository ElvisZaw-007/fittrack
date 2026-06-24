import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';

import '../entities/weight_log.dart';

class GetRecentWeightLogUseCase {
  final WeightLogRepository _repository;
  const GetRecentWeightLogUseCase(this._repository);

  Future<List<WeightLog>> call({int limit = 7}) =>
      _repository.getRecentWeightLogs(limit: limit);
}
