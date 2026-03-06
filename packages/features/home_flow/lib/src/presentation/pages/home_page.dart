import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../l10n/generated/home_localizations.dart';
import '../bloc/home_cubit.dart';
import '../widgets/home_item_card.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<HomeCubit>()..loadItems(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => switch (state) {
          HomeFailure(:final message) => DsError(
              message: message,
              retryLabel: HomeLocalizations.of(context)!.retry,
              onRetry: () => context.read<HomeCubit>().loadItems(),
            ),
          _ => _HomeContent(state: state),
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = HomeLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.router.pushPath(AppRoutes.profile),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'onboarding':
                  context.router.pushPath(AppRoutes.onboarding);
                  break;
                case 'login':
                  context.router.pushPath(AppRoutes.login);
                  break;
                case 'register':
                  context.router.pushPath(AppRoutes.register);
                  break;
                case 'logout':
                  context.router.pushPath(AppRoutes.login);
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'onboarding', child: Text('Onboarding')),
              const PopupMenuItem(value: 'login', child: Text('Login')),
              const PopupMenuItem(value: 'register', child: Text('Register')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: switch (state) {
        HomeInitial() || HomeLoading() => const DsLoading(),
        HomeLoaded(:final items) => items.isEmpty
            ? Center(child: Text(l10n.noItems))
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: items.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: HomeItemCard(item: items[index]),
                ),
              ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
