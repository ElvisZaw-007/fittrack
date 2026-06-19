import '../models/profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<void> createProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}
