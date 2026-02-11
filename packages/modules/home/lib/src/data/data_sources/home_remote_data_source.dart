import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../dtos/home_item_dto.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeItemDto>> getHomeItems();
  Future<HomeItemDto> getHomeItemById(String id);
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<HomeItemDto>> getHomeItems() async {
    final response = await _apiClient.get('/home/items');
    final list = response.data as List;
    return list.map((e) => HomeItemDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<HomeItemDto> getHomeItemById(String id) async {
    final response = await _apiClient.get('/home/items/$id');
    return HomeItemDto.fromJson(response.data as Map<String, dynamic>);
  }
}
