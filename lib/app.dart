import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'core/di/permission_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubits/auth_cubit.dart';

class CodraCareApp extends StatefulWidget {
  const CodraCareApp({super.key});

  @override
  State<CodraCareApp> createState() => _CodraCareAppState();
}

class _CodraCareAppState extends State<CodraCareApp> {
  late final AuthCubit _authCubit;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = GetIt.I<AuthCubit>()..checkAuthStatus();
    _router = createRouter(_authCubit, GetIt.I<PermissionService>());
  }

  @override
  void reassemble() {
    super.reassemble();
    _router = createRouter(_authCubit, GetIt.I<PermissionService>());
  }

  @override
  void dispose() {
    _authCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'CodraCare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: _router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
