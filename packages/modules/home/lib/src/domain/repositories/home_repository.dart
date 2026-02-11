import 'package:core/core.dart';

import '../entities/home_item.dart';

abstract class HomeRepository {
  Future<Result<List<HomeItem>>> getHomeItems();
  Future<Result<HomeItem>> getHomeItemById(String id);
}
