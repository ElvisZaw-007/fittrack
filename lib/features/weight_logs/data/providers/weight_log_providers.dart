import 'package:fittrack/features/weight_logs/data/data_sources/weight_log_remote_datasource_impl.dart';
import 'package:fittrack/features/weight_logs/domain/repositories/weight_log_repository.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/add_weight_log_usecase.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/delete_weight_log_usecase.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/get_latest_weight_usecase.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/get_recent_weight_log_usecase.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/get_weight_history_usecase.dart';
import 'package:fittrack/features/weight_logs/domain/usecases/update_weight_log_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/supabase_weight_log_repository.dart';

final weightLogRemoteDataSourceProvider = Provider((ref) {
  return WeightLogRemoteDatasourceImpl(Supabase.instance.client);
});

final weightLogRepositoryProvider = Provider<WeightLogRepository>((ref) {
  return SupabaseWeightLogRepository(
    ref.watch(weightLogRemoteDataSourceProvider),
    Supabase.instance.client,
  );
});

final addWeightLogUseCaseProvider = Provider((ref) {
  return AddWeightLogUseCase(ref.watch(weightLogRepositoryProvider));
});

final updateWeightLogUseCaseProvider = Provider((ref) {
  return UpdateWeightLogUseCase(ref.watch(weightLogRepositoryProvider));
});

final deleteWeightLogUseCaseProvider = Provider((ref) {
  return DeleteWeightLogUseCase(ref.watch(weightLogRepositoryProvider));
});

final getLatestWeightUseCaseProvider = Provider((ref) {
  return GetLatestWeightUseCase(ref.watch(weightLogRepositoryProvider));
});

final getRecentWeightLogUseCaseProvider = Provider((ref) {
  return GetRecentWeightLogUseCase(ref.watch(weightLogRepositoryProvider));
});

final getWeightHistoryUseCaseProvider = Provider((ref) {
  return GetWeightHistoryUseCase(ref.watch(weightLogRepositoryProvider));
});
