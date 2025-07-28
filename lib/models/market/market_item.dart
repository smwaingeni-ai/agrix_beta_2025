import 'dart:convert';

/// 📦 Represents an item listed in the AgriX Market.
class MarketItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String type; // ✅ crop/livestock/land/etc.
  final String contact;
  final String imagePath; // Primary image (thumbnail)
  final List<String> imagePaths; // For gallery display
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

  /// 🔁 Create MarketItem from JSON
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

  /// 🔁 Convert MarketItem to JSON
  Map<String, dynamic> toJson() {
    return {
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
  }

  /// 📅 Display-friendly posted date
  String get displayDate => postedAt.toLocal().toString().split('T').first;

  /// 🖼️ Check if an image path is set
  bool get hasImage => imagePath.isNotEmpty;

  /// 🔄 Decode a JSON string into a list of MarketItems
  static List<MarketItem> decodeList(String jsonStr) {
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => MarketItem.fromJson(e)).toList();
  }

  /// 🧾 Encode a list of MarketItems into a JSON string
  static String encodeList(List<MarketItem> items) {
    final List<Map<String, dynamic>> data =
        items.map((item) => item.toJson()).toList();
    return json.encode(data);
  }
}
