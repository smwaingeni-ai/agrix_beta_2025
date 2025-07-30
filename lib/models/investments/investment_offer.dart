class InvestmentOffer {
  final String id;
  final String investorId;
  final String title;
  final double amount;
  final String term;
  final String contact;
  final DateTime createdAt;
  final String listingId;
  final String investorName;
  final double interestRate;
  final bool isAccepted;
  final DateTime timestamp;
  final String currency;
  final int durationMonths; // ✅ Required field

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
    required this.currency,
    required this.durationMonths,
  });

  factory InvestmentOffer.fromJson(Map<String, dynamic> json) {
    return InvestmentOffer(
      id: json['id'],
      investorId: json['investorId'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      term: json['term'],
      contact: json['contact'],
      createdAt: DateTime.parse(json['createdAt']),
      listingId: json['listingId'],
      investorName: json['investorName'],
      interestRate: (json['interestRate'] as num).toDouble(),
      isAccepted: json['isAccepted'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
      currency: json['currency'],
      durationMonths: json['durationMonths'] ?? 0, // ✅ Defensive default
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
        'currency': currency,
        'durationMonths': durationMonths,
      };
}
