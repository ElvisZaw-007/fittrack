import '../entities/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:fittrack/core/errors/failures.dart';

class SaveProfileUseCase {
  final ProfileRepository _repository;
  const SaveProfileUseCase(this._repository);

  Future<Profile> call(Profile profile) async {
    //Business rules - validated before reaching the database
    if (profile.name.trim().isEmpty) {
      throw const InvalidProfileFailure('Name connot be empty.');
    }
    if (profile.age < 10 || profile.age > 120) {
      throw const InvalidProfileFailure('Age must be between 10 and 120.');
    }
    if (profile.heightCm < 50 || profile.heightCm > 300) {
      throw const InvalidProfileFailure(
        'Height must be between 50 and 300 cm.',
      );
    }
    return await _repository.saveProfile(profile);
  }
}
