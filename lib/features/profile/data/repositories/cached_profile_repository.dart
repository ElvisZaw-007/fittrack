import 'package:fittrack/core/errors/failures.dart';
import 'package:fittrack/features/profile/data/data_source/profile_local_datasource.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

import '../models/profile_model.dart';

class CachedProfileRepository implements ProfileRepository {
  final ProfileRepository _remote;
  final ProfileLocalDatasource _local;

  const CachedProfileRepository(this._remote, this._local);

  @override
  Future<Profile?> getProfile() async {
    try {
      final profile = await _remote.getProfile();

      if (profile != null) {
        await _local.cacheProfile(ProfileModel.fromEntity(profile));
      }

      return profile;
    } on NetworkFailure {
      final cached = await _local.getCachedProfile();

      return cached?.toEntity();
    }
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    final result = await _remote.createProfile(profile);

    await _local.clearCache();

    return result;
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final result = await _remote.updateProfile(profile);

    await _local.clearCache();

    return result;
  }

  @override
  Future<Profile> saveProfile(Profile profile) async {
    final existing = await _remote.getProfile();

    final Profile result;
    if (existing != null) {
      result = await _remote.updateProfile(profile);
    } else {
      result = await _remote.createProfile(profile);
    }

    await _local.clearCache();
    return result;
  }
}
