import 'package:equatable/equatable.dart';
import 'shell_destination.dart';

enum ShellNavSection {
  main(sortOrder: 0, labelKey: 'shell.main'),
  dailyWork(sortOrder: 10, labelKey: 'shell.daily_work'),
  patients(sortOrder: 20, labelKey: 'shell.patients_section'),
  finance(sortOrder: 30, labelKey: 'shell.finance'),
  management(sortOrder: 40, labelKey: 'shell.management'),
  account(sortOrder: 50, labelKey: 'shell.account');

  final int sortOrder;
  final String labelKey;

  const ShellNavSection({
    required this.sortOrder,
    required this.labelKey,
  });
}

class ShellSectionGroup extends Equatable {
  final ShellNavSection section;
  final List<ShellDestination> destinations;

  const ShellSectionGroup({
    required this.section,
    required this.destinations,
  });

  String get labelKey => section.labelKey;

  @override
  List<Object?> get props => [section, destinations];
}
