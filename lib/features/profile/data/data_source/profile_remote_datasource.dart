import '../models/profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile();
  Future<ProfileModel> saveProfile(Map<String, dynamic> payload);
}
