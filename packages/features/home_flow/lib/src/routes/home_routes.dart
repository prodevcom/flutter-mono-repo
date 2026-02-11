import 'package:auto_route/auto_route.dart';

import '../presentation/pages/home_page.dart';

part 'home_routes.gr.dart';

@AutoRouterConfig()
class HomeFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page),
      ];
}
