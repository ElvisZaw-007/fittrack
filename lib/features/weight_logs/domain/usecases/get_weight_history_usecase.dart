import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';

class GetWeightHistoryUseCase {
  final WeightLogRepository _repository;
  const GetWeightHistoryUseCase(this._repository);
  Future<List<WeightLog>> call() => _repository.getWeightHistory();
}
