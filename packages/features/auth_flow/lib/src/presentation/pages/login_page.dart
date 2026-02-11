import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../l10n/generated/auth_localizations.dart';
import '../bloc/login_cubit.dart';
import '../widgets/login_form.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => GetIt.I<LoginCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.loginTitle)),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: LoginForm(isLoading: isLoading),
            );
          },
        ),
      ),
    );
  }
}
