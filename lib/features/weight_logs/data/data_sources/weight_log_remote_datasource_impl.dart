import 'package:dio/dio.dart';
import 'package:fittrack/features/weight_logs/data/models/weight_log_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'weight_log_remote_datasource.dart';

class WeightLogRemoteDatasourceImpl implements WeightLogRemoteDatasource {
  final SupabaseClient _supabase;
  const WeightLogRemoteDatasourceImpl(this._supabase);

  @override
  Future<WeightLogModel> addWeightLog(Map<String, dynamic> payload) async {
    final response = await _supabase
        .from('weight_logs')
        .insert(payload)
        .select()
        .single();

    return WeightLogModel.fromJson(response);
  }

  @override
  Future<WeightLogModel> updateWeightLog(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _supabase
        .from('weight_logs')
        .update(payload)
        .eq('id', id)
        .select()
        .single();

    return WeightLogModel.fromJson(response);
  }

  @override
  Future<void> deleteWeightLog(String id) async {
    await _supabase.from('weight_logs').delete().eq('id', id);
  }

  @override
  Future<WeightLogModel?> getLatestWeightLogs(String userId) async {
    final response = await _supabase
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return WeightLogModel.fromJson(response);
  }

  @override
  Future<List<WeightLogModel>> getRecentWeightLogs(
    String userId, {
    int limit = 7,
  }) async {
    final response = await _supabase
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(limit);

    return response.map(WeightLogModel.fromJson).toList();
  }

  @override
  Future<List<WeightLogModel>> getWeightHistory(String userId) async {
    final response = await _supabase
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false);

    return response.map(WeightLogModel.fromJson).toList();
  }
}
