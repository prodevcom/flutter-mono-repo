import 'package:auto_route/auto_route.dart';
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
    final l10n = HomeLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => GetIt.I<HomeCubit>()..loadItems(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.homeTitle)),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => switch (state) {
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
            HomeFailure(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: AppSpacing.md),
                    DsButton(
                      label: l10n.retry,
                      onPressed: () => context.read<HomeCubit>().loadItems(),
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
