import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../l10n/generated/profile_localizations.dart';
import '../bloc/profile_cubit.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = ProfileLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => GetIt.I<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileInitial() || ProfileLoading() => const DsLoading(),
            ProfileLoaded(:final profile) => ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profile.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (profile.bio != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(profile.bio!, textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  DsButton(
                    label: l10n.editProfile,
                    variant: DsButtonVariant.outlined,
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                ],
              ),
            ProfileFailure(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: AppSpacing.md),
                    DsButton(
                      label: l10n.retry,
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                    ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
