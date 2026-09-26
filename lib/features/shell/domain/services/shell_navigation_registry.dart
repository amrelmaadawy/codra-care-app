import '../entities/shell_destination.dart';
import 'doctor_navigation_destinations.dart';
import 'reception_navigation_destinations.dart';

abstract final class ShellNavigationRegistry {
  static const List<ShellDestination> receptionDestinations =
      kReceptionDestinations;

  static const List<ShellDestination> doctorDestinations =
      kDoctorDestinations;

  static List<ShellDestination> get allDestinations => [
        ...receptionDestinations,
        ...doctorDestinations,
      ];
}
