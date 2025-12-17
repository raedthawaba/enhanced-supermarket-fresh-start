import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? profileImage;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.profileImage,
    this.role = UserRole.customer,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? profileImage,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'profileImage': profileImage,
      'role': role.toString(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      profileImage: json['profileImage'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == json['role'],
        orElse: () => UserRole.customer,
      ),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        address,
        profileImage,
        role,
        isActive,
        createdAt,
        lastLoginAt,
      ];
}

enum UserRole {
  customer,
  admin,
  delivery,
  vendor,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'عميل';
      case UserRole.admin:
        return 'مدير';
      case UserRole.delivery:
        return 'مندوب توصيل';
      case UserRole.vendor:
        return 'بائع';
    }
  }
}