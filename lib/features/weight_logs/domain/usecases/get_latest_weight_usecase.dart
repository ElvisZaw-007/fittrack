import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';
import '../entities/weight_log.dart';

class GetLatestWeightUseCase {
  final WeightLogRepository _repository;
  const GetLatestWeightUseCase(this._repository);

  Future<WeightLog?> call() => _repository.getLatestWeight();
}
