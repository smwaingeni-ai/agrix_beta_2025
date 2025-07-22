import 'dart:convert';
import 'package:agrix_africa_adt2025/models/investments/investment_horizon.dart';
import 'package:agrix_africa_adt2025/models/investments/investor_status.dart';

/// Investor profile model
class InvestorProfile {
  String id;
  String name;
  String contactNumber;
  String contact;
  String email;
  String location;
  List<InvestmentHorizon> preferredHorizons;
  InvestorStatus status;
  List<String> interests;
  DateTime registeredAt;

  InvestorProfile({
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

  /// 🔹 Safe empty constructor for forms/defaults
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
        'preferredHorizons': preferredHorizons.map((e) => e.code).toList(), // ✅ use .code
        'status': status.name,
        'interests': interests,
        'registeredAt': registeredAt.toIso8601String(),
      };

  /// 🔁 Create instance from JSON map
  factory InvestorProfile.fromJson(Map<String, dynamic> json) => InvestorProfile(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        contactNumber: json['contactNumber'] ?? '',
        contact: json['contact'] ?? '',
        email: json['email'] ?? '',
        location: json['location'] ?? '',
        preferredHorizons: (json['preferredHorizons'] as List<dynamic>?)
                ?.map((e) => InvestmentHorizonExtension.fromString(e.toString()))
                .toList() ??
            [],
        status: InvestorStatusExtension.fromName(json['status'] ?? ''),
        interests: List<String>.from(json['interests'] ?? []),
        registeredAt:
            DateTime.tryParse(json['registeredAt'] ?? '') ?? DateTime.now(),
      );

  /// 🔄 Encode a list of InvestorProfiles into JSON string
  static String encode(List<InvestorProfile> investors) =>
      json.encode(investors.map((i) => i.toJson()).toList());

  /// 🔄 Decode a JSON string into a list of InvestorProfiles
  static List<InvestorProfile> decode(String jsonStr) =>
      (json.decode(jsonStr) as List<dynamic>)
          .map((i) => InvestorProfile.fromJson(i))
          .toList();

  @override
  String toString() =>
      'InvestorProfile(name: $name, contact: $contact, status: ${status.label}, preferred: ${preferredHorizons.map((e) => e.label).join(", ")})';
}
