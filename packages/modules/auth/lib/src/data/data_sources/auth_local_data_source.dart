import 'dart:convert';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../dtos/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<UserDto?> getCachedUser();
  Future<void> cacheUser(UserDto user);
  Future<void> clearCache();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._localStorage, this._secureStorage);

  final LocalStorage _localStorage;
  final SecureStorage _secureStorage;

  static const _cachedUserKey = 'cached_user';
  static const _tokenKey = 'access_token';

  @override
  Future<UserDto?> getCachedUser() async {
    final jsonString = await _localStorage.getString(_cachedUserKey);
    if (jsonString == null) return null;
    return UserDto.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  @override
  Future<void> cacheUser(UserDto user) async {
    await _localStorage.setString(_cachedUserKey, json.encode(user.toJson()));
  }

  @override
  Future<void> clearCache() async {
    await _localStorage.remove(_cachedUserKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(_tokenKey, token);
  }

  @override
  Future<String?> getToken() => _secureStorage.read(_tokenKey);

  @override
  Future<void> clearToken() => _secureStorage.delete(_tokenKey);
}
