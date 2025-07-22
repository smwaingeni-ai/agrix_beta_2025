import 'dart:convert';

/// Represents an investment offer made by an investor on a listing.
class InvestmentOffer {
  final String id;
  final String investorName;
  final String listingId;
  final String investorId;
  final String contact;
  final double amount;
  final String currency;
  final int durationMonths;
  final String term;
  final double interestRate;
  final String message;
  final DateTime offerDate;
  final DateTime timestamp;
  final bool isAccepted;

  const InvestmentOffer({
    required this.id,
    required this.investorName,
    required this.listingId,
    required this.investorId,
    required this.contact,
    required this.amount,
    required this.currency,
    required this.durationMonths,
    required this.term,
    required this.interestRate,
    required this.message,
    required this.offerDate,
    required this.timestamp,
    this.isAccepted = false,
  });

  /// 🔹 Create a blank default offer
  factory InvestmentOffer.empty() => InvestmentOffer(
        id: '',
        investorName: '',
        listingId: '',
        investorId: '',
        contact: '',
        amount: 0.0,
        currency: 'USD',
        durationMonths: 0,
        term: '',
        interestRate: 0.0,
        message: '',
        offerDate: DateTime.now(),
        timestamp: DateTime.now(),
        isAccepted: false,
      );

  /// 🔹 Deserialize from JSON map
  factory InvestmentOffer.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return InvestmentOffer(
      id: json['id'] ?? '',
      investorName: json['investorName'] ?? '',
      listingId: json['listingId'] ?? '',
      investorId: json['investorId'] ?? '',
      contact: json['contact'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      durationMonths: json['durationMonths'] ?? 0,
      term: json['term'] ?? '',
      interestRate: (json['interestRate'] ?? 0).toDouble(),
      message: json['message'] ?? '',
      offerDate: DateTime.tryParse(json['offerDate'] ?? '') ?? now,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? now,
      isAccepted: json['isAccepted'] ?? false,
    );
  }

  /// 🔹 Serialize to JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'investorName': investorName,
        'listingId': listingId,
        'investorId': investorId,
        'contact': contact,
        'amount': amount,
        'currency': currency,
        'durationMonths': durationMonths,
        'term': term,
        'interestRate': interestRate,
        'message': message,
        'offerDate': offerDate.toIso8601String(),
        'timestamp': timestamp.toIso8601String(),
        'isAccepted': isAccepted,
      };

  /// 🔹 Encode a list of InvestmentOffer objects to a JSON string
  static String encode(List<InvestmentOffer> offers) =>
      jsonEncode(offers.map((e) => e.toJson()).toList());

  /// 🔹 Decode a JSON string to a list of InvestmentOffer objects
  static List<InvestmentOffer> decode(String jsonStr) =>
      (jsonDecode(jsonStr) as List<dynamic>)
          .map((e) => InvestmentOffer.fromJson(e))
          .toList();

  /// 🔹 Create a copy with optional overrides
  InvestmentOffer copyWith({
    String? id,
    String? investorName,
    String? listingId,
    String? investorId,
    String? contact,
    double? amount,
    String? currency,
    int? durationMonths,
    String? term,
    double? interestRate,
    String? message,
    DateTime? offerDate,
    DateTime? timestamp,
    bool? isAccepted,
  }) {
    return InvestmentOffer(
      id: id ?? this.id,
      investorName: investorName ?? this.investorName,
      listingId: listingId ?? this.listingId,
      investorId: investorId ?? this.investorId,
      contact: contact ?? this.contact,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      durationMonths: durationMonths ?? this.durationMonths,
      term: term ?? this.term,
      interestRate: interestRate ?? this.interestRate,
      message: message ?? this.message,
      offerDate: offerDate ?? this.offerDate,
      timestamp: timestamp ?? this.timestamp,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  @override
  String toString() {
    return 'InvestmentOffer(id: $id, investor: $investorName, amount: $amount $currency, accepted: $isAccepted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InvestmentOffer &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            investorName == other.investorName &&
            listingId == other.listingId &&
            investorId == other.investorId &&
            contact == other.contact &&
            amount == other.amount &&
            currency == other.currency &&
            durationMonths == other.durationMonths &&
            term == other.term &&
            interestRate == other.interestRate &&
            message == other.message &&
            offerDate == other.offerDate &&
            timestamp == other.timestamp &&
            isAccepted == other.isAccepted;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      investorName.hashCode ^
      listingId.hashCode ^
      investorId.hashCode ^
      contact.hashCode ^
      amount.hashCode ^
      currency.hashCode ^
      durationMonths.hashCode ^
      term.hashCode ^
      interestRate.hashCode ^
      message.hashCode ^
      offerDate.hashCode ^
      timestamp.hashCode ^
      isAccepted.hashCode;
}
