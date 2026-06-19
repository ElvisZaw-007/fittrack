// lib/features/profile/data/repositories/supabase_profile_repository.dart

import 'package:fittrack/features/profile/data/data_source/profile_remote_datasource.dart';
import 'package:fittrack/features/profile/data/models/profile_model.dart';
import 'package:fittrack/features/profile/domain/entities/profile.dart';
import 'package:fittrack/features/profile/domain/repositories/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const SupabaseProfileRepository(this._remoteDataSource);

  @override
  Future<Profile?> getProfile() async { 
      final model = await _remoteDataSource.getProfile();
      return model?.toEntity();
    }
  

  @override
  Future<Profile> saveProfile(Profile profile) async {
    final model = ProfileModel(
      userId: profile.userId,
    name: profile.name,
    age: profile.age,
    heightCm: profile.heightCm,
    unitPref: profile.unitPreference.name,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
 
    );
     return (await _remoteDataSource.updateProfile(model)).toEntity();
    }
  }

