import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/profile_localizations.dart';

@RoutePage()
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = ProfileLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            DsTextField(label: l10n.name),
            const SizedBox(height: AppSpacing.md),
            DsTextField(label: l10n.email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppSpacing.md),
            DsTextField(label: l10n.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: AppSpacing.md),
            DsTextField(label: l10n.bio),
            const SizedBox(height: AppSpacing.lg),
            DsButton(
              label: l10n.save,
              onPressed: () {
                // TODO: Implement update profile
              },
            ),
          ],
        ),
      ),
    );
  }
}
