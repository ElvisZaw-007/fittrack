import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile?> getProfile();
  Future<Profile> createProfile(Profile profile);
  Future<Profile> updateProfile(Profile profile);
  Future<Profile> saveProfile(Profile profile);
}
