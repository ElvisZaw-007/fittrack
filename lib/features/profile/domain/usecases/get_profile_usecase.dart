import 'package:fittrack/features/profile/domain/repositories/profile_repository.dart';
import '../entities/profile.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;
  const GetProfileUseCase(this._repository);

  Future<Profile?> call() => _repository.getProfile();
}
