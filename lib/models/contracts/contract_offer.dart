import 'dart:convert';

/// Represents a contract offer between agricultural parties.
class ContractOffer {
  final String id;
  final String title;
  final String description;
  final String location;
  final String duration;
  final String paymentTerms;
  final String contact;
  final List<String> parties;
  final bool isActive;
  final DateTime postedAt;
  final double amount;
  final String cropOrLivestockType;
  final String terms;

  const ContractOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.duration,
    required this.paymentTerms,
    required this.contact,
    required this.parties,
    required this.isActive,
    required this.postedAt,
    required this.amount,
    required this.cropOrLivestockType,
    required this.terms,
  });

  /// ✅ Fallback empty constructor (used in orElse scenarios)
  factory ContractOffer.empty() => ContractOffer(
        id: '',
        title: '',
        description: '',
        location: '',
        duration: '',
        paymentTerms: '',
        contact: '',
        parties: [],
        isActive: false,
        postedAt: DateTime.now(),
        amount: 0.0,
        cropOrLivestockType: '',
        terms: '',
      );

  /// Creates a copy of this ContractOffer with updated fields.
  ContractOffer copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? duration,
    String? paymentTerms,
    String? contact,
    List<String>? parties,
    bool? isActive,
    DateTime? postedAt,
    double? amount,
    String? cropOrLivestockType,
    String? terms,
  }) {
    return ContractOffer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      duration: duration ?? this.duration,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      contact: contact ?? this.contact,
      parties: parties ?? this.parties,
      isActive: isActive ?? this.isActive,
      postedAt: postedAt ?? this.postedAt,
      amount: amount ?? this.amount,
      cropOrLivestockType: cropOrLivestockType ?? this.cropOrLivestockType,
      terms: terms ?? this.terms,
    );
  }

  /// Deserialize from a JSON object.
  factory ContractOffer.fromJson(Map<String, dynamic> json) => ContractOffer(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        duration: json['duration'] ?? '',
        paymentTerms: json['paymentTerms'] ?? '',
        contact: json['contact'] ?? '',
        parties: List<String>.from(json['parties'] ?? []),
        isActive: json['isActive'] ?? false,
        postedAt: DateTime.tryParse(json['postedAt'] ?? '') ?? DateTime.now(),
        amount: (json['amount'] is num)
            ? (json['amount'] as num).toDouble()
            : double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
        cropOrLivestockType: json['cropOrLivestockType'] ?? '',
        terms: json['terms'] ?? '',
      );

  /// Serialize to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'duration': duration,
        'paymentTerms': paymentTerms,
        'contact': contact,
        'parties': parties,
        'isActive': isActive,
        'postedAt': postedAt.toIso8601String(),
        'amount': amount,
        'cropOrLivestockType': cropOrLivestockType,
        'terms': terms,
      };

  /// Decode a JSON string into a list of ContractOffers.
  static List<ContractOffer> listFromJson(String jsonString) {
    final data = json.decode(jsonString) as List<dynamic>;
    return data.map((e) => ContractOffer.fromJson(e)).toList();
  }

  /// Encode a list of ContractOffers into a JSON string.
  static String listToJson(List<ContractOffer> offers) {
    final data = offers.map((e) => e.toJson()).toList();
    return json.encode(data);
  }
}
