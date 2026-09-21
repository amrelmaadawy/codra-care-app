import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.accountType,
    required super.permissions,
    required super.tenantCode,
    super.phone,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final permissionsRaw = json['permissions'];
    List<String> parsedPermissions = [];
    if (permissionsRaw is List) {
      parsedPermissions = permissionsRaw.map((e) => e.toString()).toList();
    }

    return UserModel(
      id: (json['id'] is int) ? json['id'] as int : int.parse(json['id'].toString()),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      accountType: json['account_type'] as String? ?? json['role'] as String? ?? '',
      permissions: parsedPermissions,
      tenantCode: json['tenant_code'] as String? ?? '',
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'account_type': accountType,
      'permissions': permissions,
      'tenant_code': tenantCode,
      'phone': phone,
      'photo_url': photoUrl,
    };
  }
}
