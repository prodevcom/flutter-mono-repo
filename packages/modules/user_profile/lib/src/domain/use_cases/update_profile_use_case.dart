import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase implements UseCase<Profile, Profile> {
  UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<Profile>> call(Profile params) => _repository.updateProfile(params);
}
