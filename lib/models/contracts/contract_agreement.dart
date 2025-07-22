import 'dart:convert';

class ContractAgreement {
  final String agreementId;
  final String offerId;
  final String title;
  final String agreementDetails;
  final List<String> involvedParties;
  final DateTime agreementDate;
  final DateTime? expiryDate;
  final double agreedAmount;
  final bool isSigned;
  final String signedBy;
  final String contactInfo;
  final String termsSummary;

  ContractAgreement({
    required this.agreementId,
    required this.offerId,
    required this.title,
    required this.agreementDetails,
    required this.involvedParties,
    required this.agreementDate,
    this.expiryDate,
    required this.agreedAmount,
    required this.isSigned,
    required this.signedBy,
    required this.contactInfo,
    required this.termsSummary,
  });

  ContractAgreement copyWith({
    String? agreementId,
    String? offerId,
    String? title,
    String? agreementDetails,
    List<String>? involvedParties,
    DateTime? agreementDate,
    DateTime? expiryDate,
    double? agreedAmount,
    bool? isSigned,
    String? signedBy,
    String? contactInfo,
    String? termsSummary,
  }) {
    return ContractAgreement(
      agreementId: agreementId ?? this.agreementId,
      offerId: offerId ?? this.offerId,
      title: title ?? this.title,
      agreementDetails: agreementDetails ?? this.agreementDetails,
      involvedParties: involvedParties ?? this.involvedParties,
      agreementDate: agreementDate ?? this.agreementDate,
      expiryDate: expiryDate ?? this.expiryDate,
      agreedAmount: agreedAmount ?? this.agreedAmount,
      isSigned: isSigned ?? this.isSigned,
      signedBy: signedBy ?? this.signedBy,
      contactInfo: contactInfo ?? this.contactInfo,
      termsSummary: termsSummary ?? this.termsSummary,
    );
  }

  factory ContractAgreement.fromJson(Map<String, dynamic> json) {
    return ContractAgreement(
      agreementId: json['agreementId'] ?? '',
      offerId: json['offerId'] ?? '',
      title: json['title'] ?? '',
      agreementDetails: json['agreementDetails'] ?? '',
      involvedParties: List<String>.from(json['involvedParties'] ?? []),
      agreementDate: DateTime.tryParse(json['agreementDate'] ?? '') ?? DateTime.now(),
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      agreedAmount: (json['agreedAmount'] is num)
          ? (json['agreedAmount'] as num).toDouble()
          : double.tryParse(json['agreedAmount']?.toString() ?? '') ?? 0.0,
      isSigned: json['isSigned'] ?? false,
      signedBy: json['signedBy'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
      termsSummary: json['termsSummary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agreementId': agreementId,
      'offerId': offerId,
      'title': title,
      'agreementDetails': agreementDetails,
      'involvedParties': involvedParties,
      'agreementDate': agreementDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'agreedAmount': agreedAmount,
      'isSigned': isSigned,
      'signedBy': signedBy,
      'contactInfo': contactInfo,
      'termsSummary': termsSummary,
    };
  }

  static List<ContractAgreement> listFromJson(String jsonString) {
    final data = json.decode(jsonString) as List<dynamic>;
    return data.map((e) => ContractAgreement.fromJson(e)).toList();
  }
}
