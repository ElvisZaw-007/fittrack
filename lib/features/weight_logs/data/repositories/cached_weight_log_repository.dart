// lib/features/weight_logs/data/repositories/cached_weight_log_repository.dart

import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/weight_logs/data/data_sources/weight_log_local_datasource.dart';
import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';
import 'package:fittrack/features/weight_logs/data/models/weight_log_model.dart';

class CachedWeightLogRepository implements WeightLogRepository {
  final WeightLogRepository _remote; // ← SupabaseWeightLogRepository
  final WeightLogLocalDataSource _local;

  const CachedWeightLogRepository(this._remote, this._local);

  @override
  Future<List<WeightLog>> getWeightHistory() async {
    try {
      // Network first
      final logs = await _remote.getWeightHistory();
      // Cache on success — fire and forget, don't await
      await _local.saveWeightLogs(
        logs
            .map(
              (l) => WeightLogModel(
                id: l.id ?? '',
                weightKg: l.weightKg,
                loggedAt: l.loggedAt.toIso8601String(),
                notes: l.notes,
                userId: '',
                createdAt: DateTime.now(),
              ),
            )
            .toList(),
      );

      return logs;
    } on NetworkFailure {
      // Fall back to cache on network failure only
      final cached = await _local.getCachedWeightLogs();
      if (cached.isEmpty) rethrow; // no cache — propagate the error
      return cached.map((m) => m.toEntity()).toList();
    }
    // ServerFailure, PostgrestException etc. — do NOT cache, propagate
  }

  @override
  Future<WeightLog?> getLatestWeight() async {
    try {
      return await _remote.getLatestWeight();
    } on NetworkFailure {
      final cached = await _local.getCachedWeightLogs();
      if (cached.isEmpty) return null;
      return cached.first.toEntity(); // already ordered desc
    }
  }

  // Mutations always go to network — V1 does not support offline writes
  @override
  Future<WeightLog> addWeightLog(WeightLog log) async {
    final result = await _remote.addWeightLog(log);
    // Invalidate cache after successful write — next read will refresh it
    await _local.clearCache();
    return result;
  }

  @override
  Future<WeightLog> updateWeightLog(WeightLog log) async {
    final result = await _remote.updateWeightLog(log);
    await _local.clearCache();
    return result;
  }

  @override
  Future<void> deleteWeightLog(String id) async {
    await _remote.deleteWeightLog(id);
    await _local.clearCache();
  }

  @override
  Future<List<WeightLog>> getRecentWeightLogs({int limit = 7}) async {
    try {
      return await _remote.getRecentWeightLogs(limit: limit);
    } on NetworkFailure {
      final cached = await _local.getCachedWeightLogs();
      return cached.take(limit).map((m) => m.toEntity()).toList();
    }
  }
}
