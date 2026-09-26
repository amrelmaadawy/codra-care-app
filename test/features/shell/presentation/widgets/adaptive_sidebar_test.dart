import 'package:bloc_test/bloc_test.dart';
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
import 'package:medical_erp/features/shell/presentation/widgets/adaptive_sidebar.dart';
import 'package:medical_erp/features/shell/presentation/widgets/sidebar_destination_tile.dart';
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

  UserEntity makeUser() {
    return const UserEntity(
      id: 1,
      name: 'Salma Receptionist',
      email: 'salma@example.com',
      role: 'receptionist',
      accountType: 'receptionist',
      permissions: [
        'reception.view',
        'reception.appointments.view',
        'patients.view',
      ],
      tenantCode: 'tenant_code',
    );
  }

  Widget createTestWidget({
    required Widget child,
    String initialLocation = AppRoutes.reception,
  }) {
    final user = makeUser();
    permissionService.setUser(user);
    final authState = AuthAuthenticated(user);
    when(() => mockAuthCubit.state).thenReturn(authState);
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(authState));

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.reception,
          builder: (_, _) => BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: Scaffold(body: child),
          ),
        ),
        GoRoute(
          path: AppRoutes.appointments,
          builder: (_, _) => const Text('Appointments Screen'),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('AdaptiveSidebar in extended mode displays destination tiles', (tester) async {
    await tester.pumpWidget(createTestWidget(
      child: const AdaptiveSidebar(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveSidebar), findsOneWidget);
    expect(find.byType(SidebarDestinationTile), findsWidgets);
    expect(find.text('Salma Receptionist'), findsOneWidget);
  });

  testWidgets('AdaptiveSidebar in collapsed mode hides user name and shows collapse toggle', (tester) async {
    bool toggled = false;

    await tester.pumpWidget(createTestWidget(
      child: AdaptiveSidebar(
        isCollapsed: true,
        onToggleCollapse: () => toggled = true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Salma Receptionist'), findsNothing);

    final toggleBtn = find.byTooltip('shell.expand');
    expect(toggleBtn, findsOneWidget);
    await tester.tap(toggleBtn);
    expect(toggled, isTrue);
  });

  testWidgets('AdaptiveSidebar in drawer mode displays drawer content', (tester) async {
    await tester.pumpWidget(createTestWidget(
      child: const AdaptiveSidebar(isDrawer: true),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SidebarDestinationTile), findsWidgets);
    expect(find.text('Salma Receptionist'), findsOneWidget);
    // Expand/collapse button not visible in drawer mode
    expect(find.byTooltip('shell.collapse'), findsNothing);
    expect(find.byTooltip('shell.expand'), findsNothing);
  });
}
