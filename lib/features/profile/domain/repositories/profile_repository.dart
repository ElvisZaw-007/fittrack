import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile?> getProfile();
  Future<Profile> saveProfile(Profile profile);
}
