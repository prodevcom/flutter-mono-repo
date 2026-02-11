import 'package:injectable/injectable.dart';

import '../dtos/profile_dto.dart';
import 'profile_remote_data_source.dart';

@dev
@LazySingleton(as: ProfileRemoteDataSource)
class FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  ProfileDto _profile = const ProfileDto(
    id: 'fake-user-1',
    name: 'Dev User',
    email: 'dev@monoapp.com',
    phone: '+55 11 99999-0000',
    avatarUrl: null,
    bio: 'Flutter developer using MonoApp boilerplate.',
  );

  @override
  Future<ProfileDto> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _profile;
  }

  @override
  Future<ProfileDto> updateProfile(ProfileDto profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _profile = profile;
    return _profile;
  }
}
