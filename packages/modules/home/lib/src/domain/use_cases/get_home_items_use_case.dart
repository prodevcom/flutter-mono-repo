import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/home_item.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetHomeItemsUseCase implements UseCaseNoParams<List<HomeItem>> {
  GetHomeItemsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<List<HomeItem>>> call() => _repository.getHomeItems();
}
