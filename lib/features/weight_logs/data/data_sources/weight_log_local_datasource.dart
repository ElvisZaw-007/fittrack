// lib/features/weight_logs/data/data_sources/weight_log_local_datasource.dart

import '../models/weight_log_model.dart';

abstract interface class WeightLogLocalDataSource {
  Future<List<WeightLogModel>> getCachedWeightLogs();
  Future<void> saveWeightLogs(List<WeightLogModel> logs);
  Future<void> clearCache();
}
