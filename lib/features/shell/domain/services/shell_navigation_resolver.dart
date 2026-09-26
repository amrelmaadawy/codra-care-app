import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../entities/navigation_section.dart';
import '../entities/shell_destination.dart';
import 'shell_navigation_registry.dart';

class ShellNavigationResolver {
  const ShellNavigationResolver();

  List<ShellDestination> resolveDestinations(
    PermissionService permissions, {
    Map<String, bool>? featureFlags,
    List<ShellDestination>? allDestinations,
  }) {
    final accountType = permissions.accountType;
    if (accountType.isEmpty) {
      return const [];
    }

    final source = allDestinations ?? ShellNavigationRegistry.allDestinations;
    return source.where((dest) {
      if (!dest.enabled) return false;

      if (dest.allowedAccountTypes != null &&
          !dest.allowedAccountTypes!.contains(accountType)) {
        return false;
      }

      if (dest.allowedRoles != null &&
          !dest.allowedRoles!.contains(permissions.role)) {
        return false;
      }

      if (dest.featureFlag != null && featureFlags != null) {
        if (featureFlags[dest.featureFlag] == false) return false;
      }

      if (dest.requiredAnyPermissions != null &&
          dest.requiredAnyPermissions!.isNotEmpty) {
        if (!permissions.hasAny(dest.requiredAnyPermissions!)) {
          return false;
        }
      }

      if (dest.requiredAllPermissions != null &&
          dest.requiredAllPermissions!.isNotEmpty) {
        if (!permissions.hasAll(dest.requiredAllPermissions!)) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<ShellSectionGroup> resolveSections(
    PermissionService permissions, {
    Map<String, bool>? featureFlags,
    List<ShellDestination>? allDestinations,
  }) {
    final resolved = resolveDestinations(
      permissions,
      featureFlags: featureFlags,
      allDestinations: allDestinations,
    );

    final Map<ShellNavSection, List<ShellDestination>> grouped = {};
    for (final dest in resolved) {
      grouped.putIfAbsent(dest.section, () => []).add(dest);
    }

    return grouped.entries.map((entry) {
      return ShellSectionGroup(
        section: entry.key,
        destinations: entry.value
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
      );
    }).toList()
      ..sort((a, b) => a.section.sortOrder.compareTo(b.section.sortOrder));
  }

  ShellDestination? matchDestination(
    String location,
    List<ShellDestination> destinations,
  ) {
    if (location.isEmpty || destinations.isEmpty) return null;
    final cleanPath = location.split('?').first.split('#').first;

    ShellDestination? bestMatch;
    int longestMatchLength = -1;

    for (final dest in destinations) {
      final prefixes =
          dest.matchPrefixes.isNotEmpty ? dest.matchPrefixes : [dest.route];

      for (final prefix in prefixes) {
        if (cleanPath == prefix || cleanPath.startsWith('$prefix/')) {
          if (prefix.length > longestMatchLength) {
            longestMatchLength = prefix.length;
            bestMatch = dest;
          }
        }
      }
    }

    return bestMatch;
  }

  String getFirstAccessibleRoute(
    PermissionService permissions, {
    Map<String, bool>? featureFlags,
    List<ShellDestination>? allDestinations,
  }) {
    final destinations = resolveDestinations(
      permissions,
      featureFlags: featureFlags,
      allDestinations: allDestinations,
    );
    if (destinations.isNotEmpty) {
      return destinations.first.route;
    }
    return permissions.isDoctor
        ? AppRoutes.doctorDashboard
        : AppRoutes.reception;
  }
}
