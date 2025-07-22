import 'package:flutter/foundation.dart';

class OfficerProfile {
  final String officerId;
  final String fullName;
  final String email;
  final String phone;
  final String designation;
  final String region;
  final String department;
  final bool isActive;
  final DateTime joinedAt;

  OfficerProfile({
    required this.officerId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.designation,
    required this.region,
    required this.department,
    required this.isActive,
    required this.joinedAt,
  });

  /// 🔹 Empty factory for placeholder or form initialization
  factory OfficerProfile.empty() {
    return OfficerProfile(
      officerId: '',
      fullName: '',
      email: '',
      phone: '',
      designation: '',
      region: '',
      department: '',
      isActive: true,
      joinedAt: DateTime.now(),
    );
  }

  /// 🔹 From JSON with null safety
  factory OfficerProfile.fromJson(Map<String, dynamic> json) {
    return OfficerProfile(
      officerId: json['officerId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      designation: json['designation'] ?? '',
      region: json['region'] ?? '',
      department: json['department'] ?? '',
      isActive: json['isActive'] ?? true,
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      'officerId': officerId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'designation': designation,
      'region': region,
      'department': department,
      'isActive': isActive,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'OfficerProfile(officerId: $officerId, fullName: $fullName, region: $region)';
}
