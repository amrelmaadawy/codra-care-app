import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/di/permission_service.dart';
import 'package:medical_erp/core/router/app_routes.dart';
import 'package:medical_erp/features/auth/domain/entities/user_entity.dart';
import 'package:medical_erp/features/shell/domain/services/shell_navigation_registry.dart';
import 'package:medical_erp/features/shell/domain/services/shell_navigation_resolver.dart';

void main() {
  late ShellNavigationResolver resolver;
  late PermissionService permissionService;

  setUp(() {
    resolver = const ShellNavigationResolver();
    permissionService = PermissionService();
  });

  UserEntity makeUser({
    required String accountType,
    required String role,
    List<String> permissions = const [],
  }) {
    return UserEntity(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: role,
      accountType: accountType,
      permissions: permissions,
      tenantCode: 'test_tenant',
    );
  }

  group('ShellNavigationResolver - resolveDestinations', () {
    test('returns empty list for unknown or empty account type', () {
      expect(resolver.resolveDestinations(permissionService), isEmpty);

      final user = makeUser(accountType: 'guest', role: 'guest');
      permissionService.setUser(user);
      expect(resolver.resolveDestinations(permissionService), isEmpty);
    });

    test('resolves reception destinations for receptionist with permissions', () {
      final user = makeUser(
        accountType: 'receptionist',
        role: 'receptionist',
        permissions: [
          'reception.view',
          'reception.appointments.view',
          'patients.view',
          'reception.payments.create',
        ],
      );
      permissionService.setUser(user);

      final result = resolver.resolveDestinations(permissionService);
      final ids = result.map((d) => d.id).toList();

      expect(ids, contains('reception_dashboard'));
      expect(ids, contains('reception_appointments'));
      expect(ids, contains('reception_patients'));
      expect(ids, contains('reception_financial'));
      expect(ids, contains('reception_profile'));
      expect(ids, isNot(contains('reception_settings')));
      expect(ids, isNot(contains('reception_reports')));
      expect(ids, isNot(contains('doctor_dashboard')));
    });

    test('clinic_admin with settings and reports permissions can access them', () {
      final user = makeUser(
        accountType: 'clinic_admin',
        role: 'admin',
        permissions: [
          'reception.view',
          'appointments.view',
          'patients.view',
          'billing.view',
          'reports.view',
          'settings.view',
        ],
      );
      permissionService.setUser(user);

      final result = resolver.resolveDestinations(permissionService);
      final ids = result.map((d) => d.id).toList();

      expect(ids, contains('reception_reports'));
      expect(ids, contains('reception_settings'));
    });

    test('resolves doctor destinations for doctor account', () {
      final user = makeUser(
        accountType: 'doctor',
        role: 'doctor',
        permissions: ['doctor.all'],
      );
      permissionService.setUser(user);

      final result = resolver.resolveDestinations(permissionService);
      final ids = result.map((d) => d.id).toList();

      expect(ids, contains('doctor_dashboard'));
      expect(ids, contains('doctor_queue'));
      expect(ids, contains('doctor_patients'));
      expect(ids, contains('doctor_prescriptions'));
      expect(ids, contains('doctor_reports'));
      expect(ids, contains('doctor_leave_days'));
      expect(ids, contains('doctor_profile'));
      expect(ids, isNot(contains('reception_dashboard')));
    });
  });

  group('ShellNavigationResolver - resolveSections', () {
    test('groups destinations into non-empty sections in correct sort order', () {
      final user = makeUser(
        accountType: 'receptionist',
        role: 'receptionist',
        permissions: ['reception.view', 'reception.appointments.view'],
      );
      permissionService.setUser(user);

      final sections = resolver.resolveSections(permissionService);
      expect(sections, isNotEmpty);

      for (final s in sections) {
        expect(s.destinations, isNotEmpty);
      }

      // Check section ordering
      for (int i = 0; i < sections.length - 1; i++) {
        expect(
          sections[i].section.sortOrder,
          lessThanOrEqualTo(sections[i + 1].section.sortOrder),
        );
      }
    });
  });

  group('ShellNavigationResolver - matchDestination', () {
    const destinations = ShellNavigationRegistry.receptionDestinations;

    test('exact match returns correct destination', () {
      final match = resolver.matchDestination(AppRoutes.reception, destinations);
      expect(match?.id, 'reception_dashboard');
    });

    test('strips query parameters when matching', () {
      final match = resolver.matchDestination(
        '${AppRoutes.appointments}?date=2026-09-25&mode=check_in',
        destinations,
      );
      expect(match?.id, 'reception_appointments');
    });

    test('matches nested paths under matchPrefixes', () {
      final match = resolver.matchDestination(
        '${AppRoutes.patients}/123',
        destinations,
      );
      expect(match?.id, 'reception_patients');
    });

    test('returns null for unmatched route without false-positive clamp', () {
      final match = resolver.matchDestination('/login', destinations);
      expect(match, isNull);

      final matchEmpty = resolver.matchDestination('', destinations);
      expect(matchEmpty, isNull);
    });
  });

  group('ShellNavigationResolver - getFirstAccessibleRoute', () {
    test('returns first resolved route for user', () {
      final user = makeUser(
        accountType: 'receptionist',
        role: 'receptionist',
        permissions: ['reception.view'],
      );
      permissionService.setUser(user);

      final route = resolver.getFirstAccessibleRoute(permissionService);
      expect(route, AppRoutes.reception);
    });

    test('returns fallback if user has no destinations', () {
      final route = resolver.getFirstAccessibleRoute(permissionService);
      expect(route, AppRoutes.reception);
    });
  });
}
