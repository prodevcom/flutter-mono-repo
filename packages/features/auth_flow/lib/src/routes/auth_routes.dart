import 'package:auto_route/auto_route.dart';

import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';

part 'auth_routes.gr.dart';

@AutoRouterConfig()
class AuthFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
      ];
}
