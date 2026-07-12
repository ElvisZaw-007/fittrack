import 'package:fittrack/features/profile/data/models/profile_model.dart';

abstract interface class ProfileLocalDatasource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCache();
}
