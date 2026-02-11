import 'package:injectable/injectable.dart';

import '../dtos/user_dto.dart';
import 'auth_local_data_source.dart';
import 'auth_remote_data_source.dart';

@dev
@LazySingleton(as: AuthRemoteDataSource)
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  static const _fakeUser = UserDto(
    id: 'fake-user-1',
    email: 'dev@monoapp.com',
    name: 'Dev User',
    avatarUrl: null,
    isEmailVerified: true,
  );

  @override
  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _fakeUser;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<UserDto> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _fakeUser;
  }
}

@dev
@LazySingleton(as: AuthLocalDataSource)
class FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserDto? _cachedUser;
  String? _token;

  @override
  Future<UserDto?> getCachedUser() async => _cachedUser;

  @override
  Future<void> cacheUser(UserDto user) async => _cachedUser = user;

  @override
  Future<void> clearCache() async => _cachedUser = null;

  @override
  Future<void> saveToken(String token) async => _token = token;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> clearToken() async => _token = null;
}
