import 'package:auto_route/auto_route.dart';
import 'package:auth_flow/auth_flow.dart';
import 'package:home_flow/home_flow.dart';
import 'package:onboarding/onboarding.dart';
import 'package:profile_flow/profile_flow.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        ...HomeFlowRouter().routes,
        ...AuthFlowRouter().routes,
        ...OnboardingRouter().routes,
        ...ProfileFlowRouter().routes,
      ];
}
