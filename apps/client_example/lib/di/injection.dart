import 'package:auth_flow/auth_flow.dart';
import 'package:auth_module/auth_module.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:home_flow/home_flow.dart';
import 'package:home_module/home_module.dart';
import 'package:injectable/injectable.dart';
import 'package:onboarding/onboarding.dart';
import 'package:profile_flow/profile_flow.dart';
import 'package:shared/shared.dart';
import 'package:user_profile_module/user_profile_module.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(SharedPackageModule),
    ExternalModule(AuthModulePackageModule),
    ExternalModule(HomeModulePackageModule),
    ExternalModule(UserProfileModulePackageModule),
    ExternalModule(AuthFlowPackageModule),
    ExternalModule(HomeFlowPackageModule),
    ExternalModule(OnboardingPackageModule),
    ExternalModule(ProfileFlowPackageModule),
  ],
)
Future<void> configureDependencies() async => getIt.init();
