# 04 - Creating Features

A **feature** contains UI presentation — pages, widgets, blocs, routes, and i18n. Each feature maps to one or more domain modules. This guide creates an `orders_flow` feature that consumes the `orders_module`.

## Step 1: Create the Package Structure

```bash
mkdir -p packages/features/orders_flow/lib/src/{presentation/{bloc,pages,widgets},routes,l10n,di}
```

## Step 2: Create `pubspec.yaml`

```yaml
# packages/features/orders_flow/pubspec.yaml
name: orders_flow
description: Orders UI feature - routes, blocs, pages, widgets, i18n
publish_to: none
version: 0.1.0

environment:
  sdk: ^3.10.0
  flutter: ">=3.38.0"

resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  core:
    path: ../../core
  design_system:
    path: ../../design_system
  orders_module:
    path: ../../modules/orders
  auto_route: ^11.0.0
  flutter_bloc: ^9.1.0
  get_it: ^8.0.3
  injectable: ^2.5.0
  freezed_annotation: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^3.0.0
  auto_route_generator: ^10.4.0
  injectable_generator: ^2.7.0
  bloc_test: ^10.0.0
  mocktail: ^1.0.4

flutter:
  generate: true
```

## Step 3: Create the Cubit

```dart
// packages/features/orders_flow/lib/src/presentation/bloc/orders_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:orders_module/orders_module.dart';

part 'orders_cubit.freezed.dart';

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState.initial() = OrdersInitial;
  const factory OrdersState.loading() = OrdersLoading;
  const factory OrdersState.loaded(List<Order> orders) = OrdersLoaded;
  const factory OrdersState.failure(String message) = OrdersFailure;
}

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersUseCase) : super(const OrdersState.initial());

  final GetOrdersUseCase _getOrdersUseCase;

  Future<void> loadOrders() async {
    emit(const OrdersState.loading());
    final result = await _getOrdersUseCase();
    result.when(
      success: (orders) => emit(OrdersState.loaded(orders)),
      failure: (failure) => emit(OrdersState.failure(failure.message)),
    );
  }
}
```

## Step 4: Create the Page

```dart
// packages/features/orders_flow/lib/src/presentation/pages/orders_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/orders_cubit.dart';

@RoutePage()
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<OrdersCubit>()..loadOrders(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) => switch (state) {
            OrdersInitial() || OrdersLoading() => const DsLoading(),
            OrdersLoaded(:final orders) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: orders.length,
                itemBuilder: (context, index) => DsCard(
                  child: ListTile(
                    title: Text(orders[index].productName),
                    subtitle: Text(orders[index].status.name),
                    trailing: Text('\$${orders[index].total.toStringAsFixed(2)}'),
                  ),
                ),
              ),
            OrdersFailure(:final message) => Center(child: Text(message)),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
```

## Step 5: Create the Route

```dart
// packages/features/orders_flow/lib/src/routes/orders_routes.dart
import 'package:auto_route/auto_route.dart';
import '../presentation/pages/orders_page.dart';

part 'orders_routes.gr.dart';

@AutoRouterConfig()
class OrdersFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: OrdersRoute.page),
      ];
}
```

## Step 6: Create the DI Micro-Package

```dart
// packages/features/orders_flow/lib/src/di/orders_flow_di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage()
void initOrdersFlowPackageModule(GetIt getIt) {}
```

## Step 7: Add i18n (Optional)

### Create `l10n.yaml`:

```yaml
# packages/features/orders_flow/l10n.yaml
arb-dir: lib/src/l10n
template-arb-file: orders_en.arb
output-localization-file: orders_localizations.dart
output-class: OrdersLocalizations
synthetic-package: false
output-dir: lib/src/l10n/generated
```

### Create ARB files:

```json
// packages/features/orders_flow/lib/src/l10n/orders_en.arb
{
  "ordersTitle": "My Orders",
  "noOrders": "No orders yet"
}
```

## Step 8: Create the Barrel File

```dart
// packages/features/orders_flow/lib/orders_flow.dart
export 'src/presentation/bloc/orders_cubit.dart';
export 'src/presentation/pages/orders_page.dart';
export 'src/di/orders_flow_di.dart';
export 'src/di/orders_flow_di.module.dart';
export 'src/routes/orders_routes.dart';
// export 'src/l10n/generated/orders_localizations.dart';  // if using i18n
```

## Step 9: Register in the Workspace

Add to root `pubspec.yaml`:

```yaml
workspace:
  - packages/features/orders_flow   # Add this line
```

## Step 10: Integrate into the App

### 1. Add dependency in the app's `pubspec.yaml`:

```yaml
dependencies:
  orders_module:
    path: packages/modules/orders
  orders_flow:
    path: packages/features/orders_flow
```

### 2. Add the route in `app_router.dart`:

```dart
import 'package:orders_flow/orders_flow.dart';

// In routes list:
AutoRoute(page: OrdersRoute.page, path: AppRoutes.orders),
```

### 3. Add the route path in `core/lib/src/navigation/app_routes.dart`:

```dart
static const orders = '/orders';
```

### 4. Add the DI module in `injection.dart`:

```dart
ExternalModule(OrdersFlowPackageModule),
ExternalModule(OrdersModulePackageModule),
```

### 5. Add localization delegate in `app.dart` (if using i18n):

```dart
OrdersLocalizations.delegate,
```

## Step 11: Generate Code

```bash
make bootstrap
make gen
make l10n   # if using i18n
```
