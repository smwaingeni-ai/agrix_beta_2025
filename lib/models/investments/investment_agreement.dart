import 'package:flutter/foundation.dart';

/// 📄 Represents a formal agreement between an investor and a farmer.
class InvestmentAgreement {
  final String agreementId; // ✅ Primary identifier
  final String offerId;
  final String investorId;
  final String investorName;
  final String farmerId;
  final String farmerName;
  final double amount;
  final String currency;
  final String terms;
  final DateTime agreementDate;
  final DateTime startDate; // ✅ Explicit start date
  final String status; // e.g. Pending, Active, Completed
  final String? documentUrl; // Optional: PDF/image link

  const InvestmentAgreement({
    required this.agreementId,
    required this.offerId,
    required this.investorId,
    required this.investorName,
    required this.farmerId,
    required this.farmerName,
    required this.amount,
    required this.currency,
    required this.terms,
    required this.agreementDate,
    required this.startDate,
    required this.status,
    this.documentUrl,
  });

  /// ✅ ID alias for shared model compatibility
  String get id => agreementId;

  /// ✅ Fallback for legacy display logic
  DateTime get signedDate => agreementDate;

  /// 🔁 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'agreementId': agreementId,
        'offerId': offerId,
        'investorId': investorId,
        'investorName': investorName,
        'farmerId': farmerId,
        'farmerName': farmerName,
        'amount': amount,
        'currency': currency,
        'terms': terms,
        'agreementDate': agreementDate.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'status': status,
        'documentUrl': documentUrl,
      };

  /// 🔁 Deserialize from JSON
  factory InvestmentAgreement.fromJson(Map<String, dynamic> json) {
    return InvestmentAgreement(
      agreementId: json['agreementId'] ?? '',
      offerId: json['offerId'] ?? '',
      investorId: json['investorId'] ?? '',
      investorName: json['investorName'] ?? '',
      farmerId: json['farmerId'] ?? '',
      farmerName: json['farmerName'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      terms: json['terms'] ?? '',
      agreementDate: DateTime.tryParse(json['agreementDate'] ?? '') ?? DateTime.now(),
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
      documentUrl: json['documentUrl'],
    );
  }

  @override
  String toString() {
    return 'Agreement [$agreementId]: $investorName invested $amount $currency with $farmerName '
        'starting ${startDate.toLocal().toString().split(' ').first}. Status: $status';
  }
}
