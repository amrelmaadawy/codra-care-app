import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.shell);
        } else if (state is AuthError) {
          AppSnackBar.showError(context, state.failure.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.pagePadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: AppSpacing.pagePadding * 1.2,
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: AppRadius.cardRadius,
                    boxShadow: context.primaryShadow,
                    border: Border.all(
                      color: context.dividerColor,
                    ),
                  ),
                  child: const LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
