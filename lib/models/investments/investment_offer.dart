class InvestmentOffer {
  final String listingId;
  final String title;
  final String description; // ✅ Add this line
  final String type;
  final double amount;
  final List<String> parties;
  final String contact;
  final String status;
  final DateTime postedAt;
  final String currency;

  const InvestmentOffer({
    required this.listingId,
    required this.title,
    required this.description, // ✅ Ensure it's here
    required this.type,
    required this.amount,
    required this.parties,
    required this.contact,
    required this.status,
    required this.postedAt,
    required this.currency,
  });

  factory InvestmentOffer.fromJson(Map<String, dynamic> json) {
    return InvestmentOffer(
      listingId: json['listingId'],
      title: json['title'],
      description: json['description'], // ✅ Also parse here
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      parties: List<String>.from(json['parties']),
      contact: json['contact'],
      status: json['status'],
      postedAt: DateTime.parse(json['postedAt']),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() => {
        'listingId': listingId,
        'title': title,
        'description': description, // ✅ Also serialize
        'type': type,
        'amount': amount,
        'parties': parties,
        'contact': contact,
        'status': status,
        'postedAt': postedAt.toIso8601String(),
        'currency': currency,
      };
}
