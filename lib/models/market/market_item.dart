import 'dart:convert';

/// 📦 Represents an item listed in the AgriX Market.
class MarketItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String type; // ✅ e.g. crop/livestock/land
  final String contact;
  final String imagePath; // Main thumbnail
  final List<String> imagePaths; // For gallery
  final String listingType;
  final String location;
  final String ownerName;
  final String ownerContact;
  final String investmentStatus;
  final String investmentTerm;
  final List<String> contactMethods;
  final List<String> paymentOptions;
  final bool isAvailable;
  final bool isLoanAccepted;
  final bool isInvestmentOpen;
  final DateTime postedAt;

  const MarketItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.type,
    required this.contact,
    required this.imagePath,
    required this.imagePaths,
    required this.listingType,
    required this.location,
    required this.ownerName,
    required this.ownerContact,
    required this.investmentStatus,
    required this.investmentTerm,
    required this.contactMethods,
    required this.paymentOptions,
    required this.isAvailable,
    required this.isLoanAccepted,
    required this.isInvestmentOpen,
    required this.postedAt,
  });

  /// 🔄 From JSON
  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      contact: json['contact'] ?? '',
      imagePath: json['imagePath'] ?? '',
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
      listingType: json['listingType'] ?? '',
      location: json['location'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerContact: json['ownerContact'] ?? '',
      investmentStatus: json['investmentStatus'] ?? '',
      investmentTerm: json['investmentTerm'] ?? '',
      contactMethods: List<String>.from(json['contactMethods'] ?? []),
      paymentOptions: List<String>.from(json['paymentOptions'] ?? []),
      isAvailable: json['isAvailable'] ?? false,
      isLoanAccepted: json['isLoanAccepted'] ?? false,
      isInvestmentOpen: json['isInvestmentOpen'] ?? false,
      postedAt: DateTime.tryParse(json['postedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔁 To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'type': type,
        'contact': contact,
        'imagePath': imagePath,
        'imagePaths': imagePaths,
        'listingType': listingType,
        'location': location,
        'ownerName': ownerName,
        'ownerContact': ownerContact,
        'investmentStatus': investmentStatus,
        'investmentTerm': investmentTerm,
        'contactMethods': contactMethods,
        'paymentOptions': paymentOptions,
        'isAvailable': isAvailable,
        'isLoanAccepted': isLoanAccepted,
        'isInvestmentOpen': isInvestmentOpen,
        'postedAt': postedAt.toIso8601String(),
      };

  /// 🗓️ User-friendly display date
  String get displayDate => postedAt.toLocal().toString().split('T').first;

  /// 🖼️ Image presence check
  bool get hasImage => imagePath.isNotEmpty;

  /// 🔄 Decode a list from JSON string
  static List<MarketItem> decodeList(String jsonStr) {
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => MarketItem.fromJson(e)).toList();
  }

  /// 🔁 Encode a list to JSON string
  static String encodeList(List<MarketItem> items) {
    return json.encode(items.map((e) => e.toJson()).toList());
  }
}
