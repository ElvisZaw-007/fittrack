import '../entities/weight_log.dart';

abstract class WeightLogRepository {
  Future<WeightLog> addWeightLog(WeightLog log);
  Future<WeightLog> updateWeightLog(WeightLog log);
  Future<void> deleteWeightLog(String id);
  Future<WeightLog?> getLatestWeight();
  Future<List<WeightLog>> getRecentWeightLogs({int limit = 7});
  Future<List<WeightLog>> getWeightHistory();
}
