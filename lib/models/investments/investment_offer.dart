import 'dart:convert';

class InvestmentOffer {
  final String id;
  final String investorId;
  final String title;
  final double amount;
  final String term;
  final String contact;
  final DateTime createdAt;

  const InvestmentOffer({
    required this.id,
    required this.investorId,
    required this.title,
    required this.amount,
    required this.term,
    required this.contact,
    required this.createdAt,
  });

  factory InvestmentOffer.fromJson(Map<String, dynamic> json) {
    return InvestmentOffer(
      id: json['id'] ?? '',
      investorId: json['investorId'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      term: json['term'] ?? '',
      contact: json['contact'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
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
      };
}
