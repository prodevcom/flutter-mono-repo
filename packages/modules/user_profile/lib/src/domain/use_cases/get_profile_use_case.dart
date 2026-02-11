import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetProfileUseCase implements UseCaseNoParams<Profile> {
  GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<Profile>> call() => _repository.getProfile();
}
