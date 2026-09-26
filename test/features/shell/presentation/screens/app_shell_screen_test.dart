import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_erp/core/di/permission_service.dart';
import 'package:medical_erp/core/router/app_routes.dart';
import 'package:medical_erp/features/auth/domain/entities/user_entity.dart';
import 'package:medical_erp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:medical_erp/features/auth/presentation/cubits/auth_state.dart';
import 'package:medical_erp/features/shell/domain/services/shell_navigation_resolver.dart';
import 'package:medical_erp/features/shell/presentation/screens/app_shell_screen.dart';
import 'package:medical_erp/features/shell/presentation/widgets/adaptive_sidebar.dart';
import 'package:medical_erp/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late PermissionService permissionService;
  late ShellNavigationResolver resolver;

  final sl = GetIt.instance;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    permissionService = PermissionService();
    resolver = const ShellNavigationResolver();

    if (sl.isRegistered<PermissionService>()) {
      sl.unregister<PermissionService>();
    }
    sl.registerSingleton<PermissionService>(permissionService);

    if (sl.isRegistered<ShellNavigationResolver>()) {
      sl.unregister<ShellNavigationResolver>();
    }
    sl.registerSingleton<ShellNavigationResolver>(resolver);
  });

  tearDown(() {
    if (sl.isRegistered<PermissionService>()) {
      sl.unregister<PermissionService>();
    }
    if (sl.isRegistered<ShellNavigationResolver>()) {
      sl.unregister<ShellNavigationResolver>();
    }
  });

  UserEntity makeUser({
    required String accountType,
    required String role,
    List<String> permissions = const [],
  }) {
    return UserEntity(
      id: 1,
      name: 'Test Staff',
      email: 'staff@example.com',
      role: role,
      accountType: accountType,
      permissions: permissions,
      tenantCode: 'test_tenant',
    );
  }

  Widget createTestWidget({
    required UserEntity user,
    required Size screenSize,
    String initialLocation = AppRoutes.reception,
  }) {
    permissionService.setUser(user);
    final authState = AuthAuthenticated(user);
    when(() => mockAuthCubit.state).thenReturn(authState);
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(authState));

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (context, state, child) => BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: AppShellScreen(child: child),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.reception,
              builder: (_, _) => const Text('Reception Content'),
            ),
            GoRoute(
              path: AppRoutes.doctorDashboard,
              builder: (_, _) => const Text('Doctor Content'),
            ),
          ],
        ),
      ],
    );

    return MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets(
    'Receptionist mobile (<600px) does NOT render AppBottomNavBar',
    (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final user = makeUser(
        accountType: 'receptionist',
        role: 'receptionist',
        permissions: ['reception.view', 'reception.appointments.view'],
      );

      await tester.pumpWidget(createTestWidget(
        user: user,
        screenSize: const Size(360, 780),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomNavBar), findsNothing);
      expect(find.text('Reception Content'), findsOneWidget);
    },
  );

  testWidgets('Doctor mobile retains AppBottomNavBar', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final user = makeUser(
      accountType: 'doctor',
      role: 'doctor',
      permissions: ['doctor.all'],
    );

    await tester.pumpWidget(createTestWidget(
      user: user,
      screenSize: const Size(360, 780),
      initialLocation: AppRoutes.doctorDashboard,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('Doctor Content'), findsOneWidget);
  });

  testWidgets('Tablet/Desktop (>=600px) renders AdaptiveSidebar', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final user = makeUser(
      accountType: 'receptionist',
      role: 'receptionist',
      permissions: ['reception.view', 'reception.appointments.view'],
    );

    await tester.pumpWidget(createTestWidget(
      user: user,
      screenSize: const Size(800, 600),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveSidebar), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
    expect(find.text('Reception Content'), findsOneWidget);
  });

  testWidgets('Zero circular progress indicators in Shell subtree', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final user = makeUser(
      accountType: 'receptionist',
      role: 'receptionist',
      permissions: ['reception.view'],
    );

    await tester.pumpWidget(createTestWidget(
      user: user,
      screenSize: const Size(360, 780),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
  });
}
