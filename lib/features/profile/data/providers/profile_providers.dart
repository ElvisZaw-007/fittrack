// lib/features/profile/data/providers/profile_providers.dart
import 'package:fittrack/features/profile/data/data_source/profile_local_datasource.dart';
import 'package:fittrack/features/profile/data/data_source/profile_remote_datasource.dart';
import 'package:fittrack/features/profile/data/repositories/cached_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fittrack/features/auth/data/providers/auth_providers.dart';
import 'package:fittrack/features/profile/domain/repositories/profile_repository.dart';
import 'package:fittrack/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fittrack/features/profile/domain/usecases/save_profile_usecase.dart';
import '../data_source/profile_local_datasource_impl.dart';
import '../data_source/profile_remote_datasource_Impl.dart';
import '../repositories/supabase_profile_repositoy.dart';
part 'profile_providers.g.dart';

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return SupabaseProfileRepository(ref.watch(profileRemoteDataSourceProvider));
}

@riverpod
GetProfileUseCase getProfileUseCase(Ref ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
SaveProfileUseCase saveProfileUseCase(Ref ref) {
  return SaveProfileUseCase(ref.watch(profileRepositoryProvider));
}

final cachedProfileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return CachedProfileRepository(
    SupabaseProfileRepository(ref.watch(profileRemoteDataSourceProvider)),
    ref.watch(profileLocalDataSourceProvider),
  );
});

//LocalDataSource
final profileLocalDataSourceProvider = Provider<ProfileLocalDatasource>((ref) {
  return ProfileLocalDataSourceImpl();
});
