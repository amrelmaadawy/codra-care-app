import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'navigation_section.dart';

class ShellDestination extends Equatable {
  final String id;
  final String route;
  final String labelKey;
  final IconData icon;
  final IconData selectedIcon;
  final ShellNavSection section;
  final List<String>? allowedAccountTypes;
  final List<String>? allowedRoles;
  final List<String>? requiredAnyPermissions;
  final List<String>? requiredAllPermissions;
  final List<String> matchPrefixes;
  final String? featureFlag;
  final bool enabled;
  final int sortOrder;

  const ShellDestination({
    required this.id,
    required this.route,
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
    required this.section,
    this.allowedAccountTypes,
    this.allowedRoles,
    this.requiredAnyPermissions,
    this.requiredAllPermissions,
    this.matchPrefixes = const [],
    this.featureFlag,
    this.enabled = true,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        route,
        labelKey,
        icon,
        selectedIcon,
        section,
        allowedAccountTypes,
        allowedRoles,
        requiredAnyPermissions,
        requiredAllPermissions,
        matchPrefixes,
        featureFlag,
        enabled,
        sortOrder,
      ];
}
