import 'dart:convert';
import 'package:agrix_beta_2025/models/farmer_profile.dart' as model;

/// ✅ Represents any user in the AgriX system (Farmer, AREX, Trader, Investor, etc.)
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

  /// 🆓 Fallback empty user
  factory UserModel.empty() => const UserModel(
        id: '',
        name: '',
        role: 'farmer',
        passcode: '',
      );

  /// 🔁 Deserialize from raw string
  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  /// 🔁 Serialize to raw string
  String toRawJson() => json.encode(toJson());

  /// 🔁 Deserialize from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        role: (json['role'] ?? 'farmer').toString().trim().toLowerCase(),
        passcode: json['passcode'] ?? '',
        email: json['email'],
        phone: json['phone'],
      );

  /// 🔁 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'passcode': passcode,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };

  /// ✅ Construct from FarmerProfile
  factory UserModel.fromFarmer(model.FarmerProfile profile) => UserModel(
        id: profile.idNumber,
        name: profile.fullName,
        role: profile.subsidised ? 'subsidised farmer' : 'farmer',
        passcode: '',
        phone: profile.contact,
        email: null,
      );

  /// 🧱 Immutable update
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

  /// ✅ Role checks
  bool isFarmer() => role.contains('farmer');
  bool isOfficer() => role.contains('officer') || role.contains('arex');
  bool isOfficial() => role.contains('official') || role.contains('government');
  bool isInvestor() => role.contains('investor');
  bool isTrader() => role.contains('trader');
  bool isAdmin() => role.trim().toLowerCase() == 'admin';

  /// ✅ Basic integrity check
  bool isValid() => id.trim().isNotEmpty && name.trim().isNotEmpty;

  /// 🧪 Debugging
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
