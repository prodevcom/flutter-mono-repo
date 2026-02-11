/// Centralized route paths used across all features.
///
/// This avoids hardcoded strings in feature packages and ensures
/// consistency between app router definitions and feature navigation.
///
/// Usage: `context.router.pushPath(AppRoutes.login)`
abstract final class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
}
