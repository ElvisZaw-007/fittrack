import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/weight_logs/data/data_sources/weight_log_remote_datasource.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/weight_log.dart';
import '../models/weight_log_model.dart';

class SupabaseWeightLogRepository implements WeightLogRepository {
  final WeightLogRemoteDatasource _remoteDatasource;
  final SupabaseClient _client;

  const SupabaseWeightLogRepository(this._remoteDatasource, this._client);

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const ServerFailure('No authenticated user.');
    return id;
  }

  @override
  Future<WeightLog> addWeightLog(WeightLog log) async {
    try {
      final payload = WeightLogModel.toInsertJson(log, userId: _userId);
      final model = await _remoteDatasource.addWeightLog(payload);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const DuplicateWeightLogFailure();
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<WeightLog> updateWeightLog(WeightLog log) async {
    try {
      final payload = WeightLogModel.toUpdateJson(log);
      final model = await _remoteDatasource.updateWeightLog(log.id!, payload);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const DuplicateWeightLogFailure();
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteWeightLog(String id) async {
    try {
      await _remoteDatasource.deleteWeightLog(id);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<WeightLog?> getLatestWeight() async {
    final model = await _remoteDatasource.getLatestWeightLogs(_userId);
    return model?.toEntity();
  }

  @override
  Future<List<WeightLog>> getRecentWeightLogs({int limit = 7}) async {
    final models = await _remoteDatasource.getRecentWeightLogs(
      _userId,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<WeightLog>> getWeightHistory() async {
    final models = await _remoteDatasource.getWeightHistory(_userId);
    return models.map((m) => m.toEntity()).toList();
  }
}
