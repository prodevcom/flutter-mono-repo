import 'package:core/core.dart';

import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Result<Profile>> getProfile();
  Future<Result<Profile>> updateProfile(Profile profile);
}
