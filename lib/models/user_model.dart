enum UserRole {
  admin,
  secretary,
  member,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Global Admin';
      case UserRole.secretary:
        return 'Society Secretary';
      case UserRole.member:
        return 'Resident Member';
    }
  }

  String get code {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.secretary:
        return 'secretary';
      case UserRole.member:
        return 'member';
    }
  }

  static UserRole fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'secretary':
        return UserRole.secretary;
      case 'member':
      default:
        return UserRole.member;
    }
  }
}

class AppUser {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? flatNumber;
  final String societyName;
  final String avatarUrl;

  const AppUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.flatNumber,
    required this.societyName,
    this.avatarUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'role': role.code,
        'flatNumber': flatNumber,
        'societyName': societyName,
        'avatarUrl': avatarUrl,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        username: json['username'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        role: UserRoleExtension.fromCode(json['role'] as String),
        flatNumber: json['flatNumber'] as String?,
        societyName: json['societyName'] as String,
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );
}
