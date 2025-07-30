import 'package:flutter/foundation.dart';

class InvestmentAgreement {
  final String agreementId; // ✅ Primary ID
  final String offerId;
  final String investorId;
  final String investorName;
  final String farmerId;
  final String farmerName;
  final double amount;
  final String currency;
  final String terms;
  final DateTime agreementDate;
  final String status; // e.g. Pending, Approved, Completed
  final String? documentUrl;

  InvestmentAgreement({
    required this.agreementId,
    required this.offerId,
    required this.investorId,
    required this.investorName,
    required this.farmerId,
    required this.farmerName,
    required this.amount,
    this.currency = 'USD',
    required this.terms,
    required this.agreementDate,
    this.status = 'Pending',
    this.documentUrl,
  });

  /// ✅ ID alias for consistency
  String get id => agreementId;

  /// ✅ Used in dashboards
  DateTime get startDate => agreementDate;

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
        'status': status,
        'documentUrl': documentUrl,
      };

  static InvestmentAgreement fromJson(Map<String, dynamic> json) {
    return InvestmentAgreement(
      agreementId: json['agreementId'],
      offerId: json['offerId'],
      investorId: json['investorId'],
      investorName: json['investorName'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      terms: json['terms'],
      agreementDate: DateTime.tryParse(json['agreementDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
      documentUrl: json['documentUrl'],
    );
  }

  @override
  String toString() {
    return 'Agreement [$agreementId]: $investorName agreed to invest $amount $currency with $farmerName on ${agreementDate.toLocal().toString().split(' ').first}. Status: $status';
  }
}
