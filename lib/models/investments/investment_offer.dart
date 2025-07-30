import 'dart:convert';

class InvestmentOffer {
  final String id;
  final String investorId;
  final String title;
  final double amount;
  final String term;
  final String contact;
  final DateTime createdAt;

  // ✅ Extended fields
  final String listingId;
  final String investorName;
  final double interestRate;
  final bool isAccepted;
  final DateTime timestamp;
  final String currency; // ✅ NEW FIELD

  const InvestmentOffer({
    required this.id,
    required this.investorId,
    required this.title,
    required this.amount,
    required this.term,
    required this.contact,
    required this.createdAt,
    required this.listingId,
    required this.investorName,
    required this.interestRate,
    required this.isAccepted,
    required this.timestamp,
    required this.currency, // ✅ Add to constructor
  });

  factory InvestmentOffer.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return InvestmentOffer(
      id: json['id'] ?? '',
      investorId: json['investorId'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      term: json['term'] ?? '',
      contact: json['contact'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? now,
      listingId: json['listingId'] ?? '',
      investorName: json['investorName'] ?? '',
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      isAccepted: json['isAccepted'] ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? now,
      currency: json['currency'] ?? 'USD', // ✅ Default fallback
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'investorId': investorId,
        'title': title,
        'amount': amount,
        'term': term,
        'contact': contact,
        'createdAt': createdAt.toIso8601String(),
        'listingId': listingId,
        'investorName': investorName,
        'interestRate': interestRate,
        'isAccepted': isAccepted,
        'timestamp': timestamp.toIso8601String(),
        'currency': currency, // ✅ Add to JSON
      };

  @override
  String toString() {
    return 'InvestmentOffer(id: $id, investor: $investorName, amount: $amount $currency, accepted: $isAccepted)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentOffer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          investorId == other.investorId &&
          title == other.title &&
          amount == other.amount &&
          term == other.term &&
          contact == other.contact &&
          createdAt == other.createdAt &&
          listingId == other.listingId &&
          investorName == other.investorName &&
          interestRate == other.interestRate &&
          isAccepted == other.isAccepted &&
          timestamp == other.timestamp &&
          currency == other.currency;

  @override
  int get hashCode =>
      id.hashCode ^
      investorId.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      term.hashCode ^
      contact.hashCode ^
      createdAt.hashCode ^
      listingId.hashCode ^
      investorName.hashCode ^
      interestRate.hashCode ^
      isAccepted.hashCode ^
      timestamp.hashCode ^
      currency.hashCode;
}
