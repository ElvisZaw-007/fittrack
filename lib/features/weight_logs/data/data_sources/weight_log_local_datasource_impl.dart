// lib/features/weight_logs/data/data_sources/weight_log_local_datasource_impl.dart

import 'dart:convert';
import 'package:fittrack/core/hive/hive_service.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/weight_log_model.dart';
import 'weight_log_local_datasource.dart';

class WeightLogLocalDataSourceImpl implements WeightLogLocalDataSource {
  static const _key = 'cached_weight_logs';

  Box<String> get _box => HiveService.weightLogsBox;

  @override
  Future<List<WeightLogModel>> getCachedWeightLogs() async {
    final raw = _box.get(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => WeightLogModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveWeightLogs(List<WeightLogModel> logs) async {
    final json = jsonEncode(
      logs
          .map(
            (log) => {
              'id': log.id,
              'user_id': log.userId,
              'weight_kg': log.weightKg,
              'logged_at': log.loggedAt,
              'notes': log.notes,
              'created_at': log.createdAt?.toIso8601String(),
            },
          )
          .toList(),
    );
    await _box.put(_key, json);
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_key);
  }
}
