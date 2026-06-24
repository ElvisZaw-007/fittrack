import 'package:fittrack/features/weight_logs/data/models/weight_log_model.dart';

abstract interface class WeightLogRemoteDatasource {
  Future<WeightLogModel> addWeightLog(Map<String, dynamic> payload);
  Future<WeightLogModel> updateWeightLog(
    String id,
    Map<String, dynamic> payload,
  );
  Future<void> deleteWeightLog(String id);
  Future<WeightLogModel?> getLatestWeightLogs(String userId);
  Future<List<WeightLogModel>> getRecentWeightLogs(
    String userId, {
    int limit = 7,
  });
  Future<List<WeightLogModel>> getWeightHistory(String userId);
}
