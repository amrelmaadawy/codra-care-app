import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tenantCodeController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tenantCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            tenantCode: _tenantCodeController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'auth.login_title'.tr(),
                style: AppTypography.headlineLarge.copyWith(
                  color: context.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'auth.login_subtitle'.tr(),
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textMutedColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                controller: _tenantCodeController,
                labelKey: 'auth.tenant_code_label',
                hintKey: 'auth.tenant_code_label',
                prefixIcon: AppIcons.clinic,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'auth.tenant_code_required'.tr()
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _emailController,
                labelKey: 'auth.email_label',
                hintKey: 'auth.email_label',
                prefixIcon: AppIcons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'auth.email_required'.tr()
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _passwordController,
                labelKey: 'auth.password_label',
                hintKey: 'auth.password_label',
                prefixIcon: AppIcons.lock,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                enabled: !isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? AppIcons.visibility
                        : AppIcons.visibilityOff,
                    size: AppSizes.iconMd,
                    color: context.textMutedColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'auth.password_required'.tr()
                    : null,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                labelKey: 'auth.login_button',
                onPressed: _submit,
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
