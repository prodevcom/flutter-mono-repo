# 03 - Creating Modules

A **module** contains domain logic and data — no UI. This guide walks through creating a new module from scratch, using the `auth` module as a reference.

## Step 1: Create the Package Structure

```bash
mkdir -p packages/modules/orders/lib/src/{domain/{entities,repositories,use_cases},data/{dtos,data_sources,repositories},di}
```

## Step 2: Create `pubspec.yaml`

```yaml
# packages/modules/orders/pubspec.yaml
name: orders_module
description: Orders domain module - entities, repositories, use cases, data
publish_to: none
version: 0.1.0

environment:
  sdk: ^3.10.0
  flutter: ">=3.38.0"

resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../core
  get_it: ^8.0.3
  injectable: ^2.5.0
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^3.0.0
  json_serializable: ^6.9.4
  injectable_generator: ^2.7.0
  mocktail: ^1.0.4
```

## Step 3: Create the Entity

```dart
// packages/modules/orders/lib/src/domain/entities/order.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String productName,
    required double total,
    required OrderStatus status,
  }) = _Order;
}

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }
```

## Step 4: Create the Repository Interface

```dart
// packages/modules/orders/lib/src/domain/repositories/order_repository.dart
import 'package:core/core.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders();
  Future<Result<Order>> getOrderById(String id);
}
```

## Step 5: Create the Use Case

```dart
// packages/modules/orders/lib/src/domain/use_cases/get_orders_use_case.dart
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

@lazySingleton
class GetOrdersUseCase extends UseCase<NoParams, List<Order>> {
  GetOrdersUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Result<List<Order>>> call([NoParams? params]) => _repository.getOrders();
}
```

## Step 6: Create the DTO

```dart
// packages/modules/orders/lib/src/data/dtos/order_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@freezed
abstract class OrderDto with _$OrderDto {
  const OrderDto._();

  const factory OrderDto({
    required String id,
    required String productName,
    required double total,
    required String status,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);

  Order toEntity() => Order(
        id: id,
        productName: productName,
        total: total,
        status: OrderStatus.values.firstWhere((e) => e.name == status),
      );
}
```

## Step 7: Create the Data Sources

### Remote Data Source (prod + stg)

```dart
// packages/modules/orders/lib/src/data/data_sources/order_remote_data_source.dart
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import '../dtos/order_dto.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderDto>> getOrders();
  Future<OrderDto> getOrderById(String id);
}

@prod
@Environment('stg')
@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<OrderDto>> getOrders() async {
    final response = await _apiClient.get('/orders');
    final list = response.data as List;
    return list.map((e) => OrderDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<OrderDto> getOrderById(String id) async {
    final response = await _apiClient.get('/orders/$id');
    return OrderDto.fromJson(response.data as Map<String, dynamic>);
  }
}
```

### Fake Data Source (dev)

```dart
// packages/modules/orders/lib/src/data/data_sources/order_fake_data_source.dart
import 'package:injectable/injectable.dart';
import '../dtos/order_dto.dart';
import 'order_remote_data_source.dart';

@dev
@LazySingleton(as: OrderRemoteDataSource)
class FakeOrderRemoteDataSource implements OrderRemoteDataSource {
  static const _fakeOrders = [
    OrderDto(id: '1', productName: 'Flutter Course', total: 49.90, status: 'confirmed'),
    OrderDto(id: '2', productName: 'Dart Masterclass', total: 29.90, status: 'pending'),
  ];

  @override
  Future<List<OrderDto>> getOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _fakeOrders;
  }

  @override
  Future<OrderDto> getOrderById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _fakeOrders.firstWhere((o) => o.id == id);
  }
}
```

## Step 8: Create the Repository Implementation

```dart
// packages/modules/orders/lib/src/data/repositories/order_repository_impl.dart
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../data_sources/order_remote_data_source.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._remoteDataSource);
  final OrderRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final dtos = await _remoteDataSource.getOrders();
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } on ApiException catch (e) {
      return Result.failure(Failure(e.message));
    }
  }

  @override
  Future<Result<Order>> getOrderById(String id) async {
    try {
      final dto = await _remoteDataSource.getOrderById(id);
      return Result.success(dto.toEntity());
    } on ApiException catch (e) {
      return Result.failure(Failure(e.message));
    }
  }
}
```

## Step 9: Create the DI Micro-Package

```dart
// packages/modules/orders/lib/src/di/orders_module_di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage()
void initOrdersModulePackageModule(GetIt getIt) {}
```

## Step 10: Create the Barrel File

```dart
// packages/modules/orders/lib/orders_module.dart
export 'src/domain/entities/order.dart';
export 'src/domain/repositories/order_repository.dart';
export 'src/domain/use_cases/get_orders_use_case.dart';
export 'src/data/dtos/order_dto.dart';
export 'src/data/data_sources/order_remote_data_source.dart';
export 'src/data/data_sources/order_fake_data_source.dart';
export 'src/data/repositories/order_repository_impl.dart';
export 'src/di/orders_module_di.dart';
export 'src/di/orders_module_di.module.dart';
```

## Step 11: Register in the Workspace

Add to root `pubspec.yaml`:

```yaml
workspace:
  - packages/modules/orders   # Add this line
```

## Step 12: Generate Code

```bash
make bootstrap
cd packages/modules/orders && dart run build_runner build --delete-conflicting-outputs
```

## Step 13: Integrate into the App

Add the dependency and DI module to the app. See [04 - Creating Features](04-creating-features.md) for the UI layer, and [06 - Dependency Injection](06-dependency-injection.md) for wiring.
