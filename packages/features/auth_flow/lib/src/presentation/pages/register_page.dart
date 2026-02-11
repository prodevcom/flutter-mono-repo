import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/auth_localizations.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsTextField(label: l10n.name, hint: l10n.nameHint),
            const SizedBox(height: AppSpacing.md),
            DsTextField(
              label: l10n.email,
              hint: l10n.emailHint,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.md),
            DsTextField(
              label: l10n.password,
              hint: l10n.passwordHint,
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            DsButton(
              label: l10n.register,
              onPressed: () {
                context.router.pushPath(AppRoutes.home);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DsButton(
              label: l10n.login,
              variant: DsButtonVariant.text,
              onPressed: () => context.router.pushPath(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
