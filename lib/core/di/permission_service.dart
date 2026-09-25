import '../../features/auth/domain/entities/user_entity.dart';

class PermissionService {
  List<String> _permissions = [];
  String _accountType = '';
  String _role = '';

  void setUser(UserEntity user) {
    _permissions = List.unmodifiable(user.permissions);
    _accountType = user.accountType;
    _role = user.role;
  }

  void clear() {
    _permissions = [];
    _accountType = '';
    _role = '';
  }

  bool has(String permission) => _permissions.contains(permission);

  bool hasAny(List<String> permissions) =>
      permissions.any(_permissions.contains);

  bool hasAll(List<String> permissions) =>
      permissions.every(_permissions.contains);

  bool get isDoctor => _accountType == 'doctor';
  bool get isReceptionist => _accountType == 'receptionist';
  bool get isClinicAdmin => _accountType == 'clinic_admin';
  bool get isPatient => _accountType == 'patient';

  bool get canAccessReceptionDashboard =>
      isReceptionist ||
      isClinicAdmin ||
      hasAny([
        'reception.appointments.view',
        'reception.queue.view',
        'appointments.view',
        'queue.view',
      ]);

  bool get canAddWalkIn =>
      isReceptionist ||
      isClinicAdmin ||
      hasAny([
        'reception.appointments.create',
        'appointments.create',
        'reception.booking.walk_in',
      ]);

  bool get canCheckIn =>
      isReceptionist ||
      isClinicAdmin ||
      hasAny([
        'reception.appointments.check_in',
        'appointments.check_in',
      ]);

  String get accountType => _accountType;
  String get role => _role;
  List<String> get permissions => _permissions;
}

