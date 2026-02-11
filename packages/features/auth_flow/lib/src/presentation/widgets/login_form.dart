import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/generated/auth_localizations.dart';
import '../bloc/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          DsTextField(
            controller: _emailController,
            label: l10n.email,
            hint: l10n.emailHint,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.emailRequired;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DsTextField(
            controller: _passwordController,
            label: l10n.password,
            hint: l10n.passwordHint,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.passwordRequired;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          DsButton(
            label: l10n.login,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _onSubmit,
          ),
          const SizedBox(height: AppSpacing.md),
          DsButton(
            label: l10n.register,
            variant: DsButtonVariant.text,
            onPressed: () => AutoRouter.of(context).pushPath(AppRoutes.register),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }
}
