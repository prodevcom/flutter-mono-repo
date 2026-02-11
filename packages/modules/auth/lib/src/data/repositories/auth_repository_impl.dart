import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<User>> login({required String email, required String password}) async {
    try {
      final dto = await _remoteDataSource.login(email: email, password: password);
      await _localDataSource.cacheUser(dto);
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearCache();
      await _localDataSource.clearToken();
      return Result.success(null);
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final dto = await _remoteDataSource.getCurrentUser();
      await _localDataSource.cacheUser(dto);
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      // Fallback to cached user
      final cached = await _localDataSource.getCachedUser();
      if (cached != null) return Result.success(cached.toEntity());
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Result<bool>> get isAuthenticated async {
    try {
      final token = await _localDataSource.getToken();
      return Result.success(token != null);
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }
}
