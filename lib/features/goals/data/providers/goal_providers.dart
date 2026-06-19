// lib/features/goals/data/providers/goal_providers.dart

import 'package:fittrack/features/goals/data/data_source/goal_remote_datasource.dart';
import 'package:fittrack/features/goals/data/data_source/goal_remote_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/goal_repository.dart';
import '../../domain/usecases/abandom_goal_usecase.dart';
import '../../domain/usecases/complete_goal_usecases.dart';
import '../../domain/usecases/create_goal_usecase.dart';
import '../../domain/usecases/get_active_goal_usecase.dart';
import '../../domain/usecases/get_goal_history_usecase.dart';

import '../repositories/supabase_goal_repository.dart';

final goalRemoteDataSourceProvider = Provider<GoalRemoteDataSource>((ref) {
  return GoalRemoteDataSourceImpl(Supabase.instance.client);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return SupabaseGoalRepository(ref.watch(goalRemoteDataSourceProvider));
});

final createGoalUseCaseProvider = Provider<CreateGoalUseCase>((ref) {
  return CreateGoalUseCase(ref.watch(goalRepositoryProvider));
});

final getActiveGoalUseCaseProvider = Provider<GetActiveGoalUseCase>((ref) {
  return GetActiveGoalUseCase(ref.watch(goalRepositoryProvider));
});

final getGoalHistoryUseCaseProvider = Provider<GetGoalHistoryUseCase>((ref) {
  return GetGoalHistoryUseCase(ref.watch(goalRepositoryProvider));
});

final completeGoalUseCaseProvider = Provider<CompleteGoalUseCase>((ref) {
  return CompleteGoalUseCase(ref.watch(goalRepositoryProvider));
});

final abandonGoalUseCaseProvider = Provider<AbandonGoalUseCase>((ref) {
  return AbandonGoalUseCase(ref.watch(goalRepositoryProvider));
});
