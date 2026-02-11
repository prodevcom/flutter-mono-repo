import 'package:auto_route/auto_route.dart';
import 'package:auth_flow/auth_flow.dart';
import 'package:core/core.dart';
import 'package:home_flow/home_flow.dart';
import 'package:onboarding/onboarding.dart';
import 'package:profile_flow/profile_flow.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: AppRoutes.home, initial: true),
        AutoRoute(page: LoginRoute.page, path: AppRoutes.login),
        AutoRoute(page: RegisterRoute.page, path: AppRoutes.register),
        AutoRoute(page: OnboardingRoute.page, path: AppRoutes.onboarding),
        AutoRoute(page: ProfileRoute.page, path: AppRoutes.profile),
        AutoRoute(page: EditProfileRoute.page, path: AppRoutes.editProfile),
      ];
}
