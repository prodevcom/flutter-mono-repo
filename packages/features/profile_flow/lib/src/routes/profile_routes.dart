import 'package:auto_route/auto_route.dart';

import '../presentation/pages/edit_profile_page.dart';
import '../presentation/pages/profile_page.dart';

part 'profile_routes.gr.dart';

@AutoRouterConfig()
class ProfileFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: EditProfileRoute.page),
      ];
}
