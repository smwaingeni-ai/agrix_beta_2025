// /lib/models/loan/loan_application.dart

import 'dart:convert';
import 'package:agrix_beta_2025/models/farmer_profile.dart';

/// 💰 Loan Application Model
class LoanApplication {
  final String id;
  final String farmerId;
  final double amount;
  final String purpose;
  final int durationMonths;
  final DateTime applicationDate;
  final String status; // e.g., 'Pending', 'Approved', 'Rejected'

  /// Optional embedded farmer profile (not persisted, for display only)
  final FarmerProfile? farmerProfile;

  LoanApplication({
    required this.id,
    required this.farmerId,
    required this.amount,
    required this.purpose,
    required this.durationMonths,
    required this.applicationDate,
    required this.status,
    this.farmerProfile,
  });

  /// 🔄 From JSON
  factory LoanApplication.fromJson(Map<String, dynamic> json) => LoanApplication(
        id: json['id'] ?? '',
        farmerId: json['farmerId'] ?? '',
        amount: (json['amount'] as num).toDouble(),
        purpose: json['purpose'] ?? '',
        durationMonths: json['durationMonths'] ?? 0,
        applicationDate: DateTime.parse(json['applicationDate']),
        status: json['status'] ?? 'Pending',
      );

  /// 🔄 To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'farmerId': farmerId,
        'amount': amount,
        'purpose': purpose,
        'durationMonths': durationMonths,
        'applicationDate': applicationDate.toIso8601String(),
        'status': status,
      };

  /// 🧾 Raw JSON support
  factory LoanApplication.fromRawJson(String str) =>
      LoanApplication.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  /// 🧬 CopyWith utility
  LoanApplication copyWith({
    String? id,
    String? farmerId,
    double? amount,
    String? purpose,
    int? durationMonths,
    DateTime? applicationDate,
    String? status,
    FarmerProfile? farmerProfile,
  }) {
    return LoanApplication(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      amount: amount ?? this.amount,
      purpose: purpose ?? this.purpose,
      durationMonths: durationMonths ?? this.durationMonths,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      farmerProfile: farmerProfile ?? this.farmerProfile,
    );
  }

  /// 🔍 Display helpers (based on FarmerProfile, if available)
  String get applicantName => farmerProfile?.displayName ?? 'Farmer $farmerId';
  String get contact => farmerProfile?.contact ?? '';
  String get farmSizeStr => farmerProfile?.farmSize?.toStringAsFixed(1) ?? '-';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanApplication &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          farmerId == other.farmerId &&
          amount == other.amount &&
          purpose == other.purpose &&
          durationMonths == other.durationMonths &&
          applicationDate == other.applicationDate &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      farmerId.hashCode ^
      amount.hashCode ^
      purpose.hashCode ^
      durationMonths.hashCode ^
      applicationDate.hashCode ^
      status.hashCode;

  bool get isValid =>
      id.isNotEmpty &&
      farmerId.isNotEmpty &&
      amount > 0 &&
      purpose.isNotEmpty &&
      durationMonths > 0;

  static List<LoanApplication> decodeList(String jsonStr) =>
      (jsonDecode(jsonStr) as List)
          .map((e) => LoanApplication.fromJson(e))
          .toList();

  static String encodeList(List<LoanApplication> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());
}
