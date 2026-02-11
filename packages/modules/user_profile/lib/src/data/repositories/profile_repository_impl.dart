import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../dtos/profile_dto.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Profile>> getProfile() async {
    try {
      final dto = await _remoteDataSource.getProfile();
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Result<Profile>> updateProfile(Profile profile) async {
    try {
      final dto = await _remoteDataSource.updateProfile(ProfileDto.fromEntity(profile));
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }
}
