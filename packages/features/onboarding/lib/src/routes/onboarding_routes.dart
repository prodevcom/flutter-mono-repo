import 'package:auto_route/auto_route.dart';

import '../presentation/pages/onboarding_page.dart';

part 'onboarding_routes.gr.dart';

@AutoRouterConfig()
class OnboardingRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: OnboardingRoute.page),
      ];
}
