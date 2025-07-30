import 'dart:convert';
import 'package:agrix_beta_2025/models/investments/investment_horizon.dart';
import 'package:agrix_beta_2025/models/investments/investor_status.dart';

/// Represents an investor's profile in the AgriX investment ecosystem.
class InvestorProfile {
  final String id;
  final String name;
  final String contactNumber;
  final String contact;
  final String email;
  final String location;
  final List<InvestmentHorizon> preferredHorizons;
  final InvestorStatus status;
  final List<String> interests;
  final DateTime registeredAt;

  const InvestorProfile({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.contact,
    required this.email,
    required this.location,
    required this.preferredHorizons,
    required this.status,
    required this.interests,
    required this.registeredAt,
  });

  /// ✅ Computed aliases for UI compatibility
  String get fullName => name;
  String get phone => contactNumber;
  List<String> get interestAreas => interests;

  /// 🔹 Default empty profile
  factory InvestorProfile.empty() => InvestorProfile(
        id: '',
        name: '',
        contactNumber: '',
        contact: '',
        email: '',
        location: '',
        preferredHorizons: [],
        status: InvestorStatus.open,
        interests: [],
        registeredAt: DateTime.now(),
      );

  /// 🔁 Convert to JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contactNumber': contactNumber,
        'contact': contact,
        'email': email,
        'location': location,
        'preferredHorizons': preferredHorizons.map((e) => e.code).toList(),
        'status': status.name,
        'interests': interests,
        'registeredAt': registeredAt.toIso8601String(),
      };

  /// 🔁 Create from JSON map
  factory InvestorProfile.fromJson(Map<String, dynamic> json) => InvestorProfile(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        contactNumber: json['contactNumber'] ?? '',
        contact: json['contact'] ?? '',
        email: json['email'] ?? '',
        location: json['location'] ?? '',
        preferredHorizons: (json['preferredHorizons'] as List<dynamic>? ?? [])
            .map((e) => InvestmentHorizonUtils.fromString(e.toString()))
            .toList(),
        status: InvestorStatusExtension.fromName(json['status'] ?? ''),
        interests: List<String>.from(json['interests'] ?? []),
        registeredAt:
            DateTime.tryParse(json['registeredAt'] ?? '') ?? DateTime.now(),
      );

  /// 🔁 Encode/decode helpers
  static String encode(List<InvestorProfile> investors) =>
      jsonEncode(investors.map((i) => i.toJson()).toList());

  static List<InvestorProfile> decode(String jsonStr) =>
      (jsonDecode(jsonStr) as List<dynamic>)
          .map((i) => InvestorProfile.fromJson(i))
          .toList();

  @override
  String toString() =>
      'InvestorProfile(name: $name, contact: $contact, status: ${status.label}, interests: ${interests.join(', ')})';
}
