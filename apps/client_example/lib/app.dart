import 'package:auth_flow/auth_flow.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_flow/home_flow.dart';
import 'package:onboarding/onboarding.dart';
import 'package:profile_flow/profile_flow.dart';

import 'app_router.dart';
import 'l10n/generated/app_localizations.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Client Example',
      theme: ClientExampleTheme.light,
      darkTheme: ClientExampleTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        DsLocalizations.delegate,
        AuthLocalizations.delegate,
        HomeLocalizations.delegate,
        OnboardingLocalizations.delegate,
        ProfileLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
