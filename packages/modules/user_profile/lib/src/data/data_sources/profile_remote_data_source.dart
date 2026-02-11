import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../dtos/profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDto> getProfile();
  Future<ProfileDto> updateProfile(ProfileDto profile);
}

@prod
@Environment('stg')
@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileDto> getProfile() async {
    final response = await _apiClient.get('/profile');
    return ProfileDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileDto> updateProfile(ProfileDto profile) async {
    final response = await _apiClient.put('/profile', data: profile.toJson());
    return ProfileDto.fromJson(response.data as Map<String, dynamic>);
  }
}
