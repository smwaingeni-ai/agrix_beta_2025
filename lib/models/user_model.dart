import 'dart:convert';
import 'package:agrix_beta_2025/models/farmer_profile.dart' as model;

/// Represents a registered user in the AgriX system.
class UserModel {
  final String id;
  final String name;
  final String role;
  final String passcode;
  final String? email;
  final String? phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.passcode,
    this.email,
    this.phone,
  });

  /// Returns an empty/default user model
  factory UserModel.empty() => const UserModel(
        id: '',
        name: '',
        role: 'farmer',
        passcode: '',
      );

  /// Parses from raw JSON string
  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  /// Converts to raw JSON string
  String toRawJson() => json.encode(toJson());

  /// Parses from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        role: (json['role'] ?? 'farmer').toString().trim().toLowerCase(),
        passcode: json['passcode'] ?? '',
        email: json['email'],
        phone: json['phone'],
      );

  /// Converts this model to JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'passcode': passcode,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };

  /// Converts from a FarmerProfile model (during login or profile mapping)
  factory UserModel.fromFarmer(model.FarmerProfile profile) => UserModel(
        id: profile.idNumber,
        name: profile.fullName,
        role: profile.subsidised ? 'subsidised farmer' : 'farmer',
        passcode: '',
        phone: profile.contact,
      );

  /// Returns a new model with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? role,
    String? passcode,
    String? email,
    String? phone,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role?.trim().toLowerCase() ?? this.role,
        passcode: passcode ?? this.passcode,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  /// Checks if this model is valid
  bool isValid() => id.isNotEmpty && name.isNotEmpty;

  /// Role match helpers — all normalized (lowercase, trimmed)
  bool isFarmer() => role.contains('farmer');
  bool isOfficer() => role.contains('officer');
  bool isOfficial() => role.contains('official');
  bool isInvestor() => role.contains('investor');
  bool isTrader() => role.contains('trader');
  bool isAdmin() => role == 'admin';

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, role: $role, passcode: $passcode, email: $email, phone: $phone)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          role == other.role &&
          passcode == other.passcode &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      role.hashCode ^
      passcode.hashCode ^
      (email?.hashCode ?? 0) ^
      (phone?.hashCode ?? 0);
}
