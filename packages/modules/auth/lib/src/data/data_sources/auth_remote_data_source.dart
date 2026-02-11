import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../dtos/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> login({required String email, required String password});
  Future<void> logout();
  Future<UserDto> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<UserDto> login({required String email, required String password}) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
  }

  @override
  Future<UserDto> getCurrentUser() async {
    final response = await _apiClient.get('/auth/me');
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }
}
