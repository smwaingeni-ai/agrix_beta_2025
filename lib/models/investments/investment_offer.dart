import 'package:flutter/foundation.dart';

class InvestmentOffer {
  final String id;
  final String title;
  final String description;
  final String type;
  final double amount;
  final List<String> parties;
  final String contact;
  final String status;
  final DateTime postedAt;
  final String currency;

  // Additional fields used across the app
  final String investorName;
  final double interestRate;
  final String term;
  final bool isAccepted;
  final DateTime timestamp;
  final DateTime createdAt;

  const InvestmentOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.amount,
    required this.parties,
    required this.contact,
    required this.status,
    required this.postedAt,
    required this.currency,
    required this.investorName,
    required this.interestRate,
    required this.term,
    required this.isAccepted,
    required this.timestamp,
    required this.createdAt,
  });

  factory InvestmentOffer.fromJson(Map<String, dynamic> json) => InvestmentOffer(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        type: json['type'],
        amount: (json['amount'] as num).toDouble(),
        parties: List<String>.from(json['parties'] ?? []),
        contact: json['contact'],
        status: json['status'],
        postedAt: DateTime.parse(json['postedAt']),
        currency: json['currency'],
        investorName: json['investorName'],
        interestRate: (json['interestRate'] as num).toDouble(),
        term: json['term'],
        isAccepted: json['isAccepted'] ?? false,
        timestamp: DateTime.parse(json['timestamp']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'amount': amount,
        'parties': parties,
        'contact': contact,
        'status': status,
        'postedAt': postedAt.toIso8601String(),
        'currency': currency,
        'investorName': investorName,
        'interestRate': interestRate,
        'term': term,
        'isAccepted': isAccepted,
        'timestamp': timestamp.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };
}
