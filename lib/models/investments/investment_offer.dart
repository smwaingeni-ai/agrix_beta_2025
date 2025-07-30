import 'package:flutter/foundation.dart';

/// 📄 Represents an investment offer made by an investor.
class InvestmentOffer {
  final String id;               // 🔑 Unique ID for the offer
  final String listingId;        // 🔗 ID referencing the target listing (farm/project)
  final String investorId;       // 👤 The investor making the offer

  final String title;            // 📌 Offer title
  final String description;      // 📝 Description of investment
  final String type;             // 🧩 e.g. Crop, Livestock, Technology
  final double amount;           // 💵 Investment amount
  final List<String> parties;    // 👥 Related parties (investor, farmer)
  final String contact;          // ☎️ Preferred contact method
  final String status;           // ⏳ Open, Accepted, Declined
  final DateTime postedAt;       // 🗓️ Original listing post date
  final String currency;         // 💱 e.g. USD

  final String investorName;     // 🧾 Display name
  final double interestRate;     // 📈 Expected return %
  final String term;             // ⌛ Duration label
  final bool isAccepted;         // ✅ Status flag
  final DateTime timestamp;      // 🕒 Offer submission time
  final DateTime createdAt;      // 🧾 Database record time

  const InvestmentOffer({
    required this.id,
    required this.listingId,
    required this.investorId,
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

  /// 🔁 Factory for creating an instance from JSON.
  factory InvestmentOffer.fromJson(Map<String, dynamic> json) => InvestmentOffer(
        id: json['id'] ?? '',
        listingId: json['listingId'] ?? '',
        investorId: json['investorId'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        type: json['type'] ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        parties: List<String>.from(json['parties'] ?? []),
        contact: json['contact'] ?? '',
        status: json['status'] ?? 'Open',
        postedAt: DateTime.tryParse(json['postedAt'] ?? '') ?? DateTime.now(),
        currency: json['currency'] ?? 'USD',
        investorName: json['investorName'] ?? '',
        interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
        term: json['term'] ?? '',
        isAccepted: json['isAccepted'] ?? false,
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  /// 🔁 Convert instance to JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'investorId': investorId,
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
