import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/home_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<HomeItem>>> getHomeItems() async {
    try {
      final dtos = await _remoteDataSource.getHomeItems();
      return Result.success(dtos.map((e) => e.toEntity()).toList());
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Result<HomeItem>> getHomeItemById(String id) async {
    try {
      final dto = await _remoteDataSource.getHomeItemById(id);
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      return Result.failure(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      return Result.failure(UnexpectedFailure(message: e.toString(), stackTrace: st));
    }
  }
}
