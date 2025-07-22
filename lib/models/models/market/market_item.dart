// /lib/models/market/market_item.dart

import 'dart:convert';

/// 📦 Represents an item listed in the AgriX Market.
class MarketItem {
  final String id;             // Unique ID (UUID)
  final String title;          // Item title (e.g., Maize Seeds, Goat)
  final String description;    // Detailed description
  final double price;          // Price in ZMW
  final String category;       // Crops, Livestock, Land, Tools, etc.
  final String contact;        // Phone, WhatsApp or email
  final String imagePath;      // Local image asset or gallery path
  final String postedAt;       // ISO8601 timestamp

  MarketItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.contact,
    required this.imagePath,
    required this.postedAt,
  });

  /// 🔁 Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'contact': contact,
        'imagePath': imagePath,
        'postedAt': postedAt,
      };

  /// 🔁 Create from JSON
  factory MarketItem.fromJson(Map<String, dynamic> json) => MarketItem(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] is int)
            ? (json['price'] as int).toDouble()
            : (json['price'] as num).toDouble(),
        category: json['category'] ?? '',
        contact: json['contact'] ?? '',
        imagePath: json['imagePath'] ?? '',
        postedAt: json['postedAt'] ?? '',
      );

  /// 🔁 Convert a raw JSON string to a MarketItem
  factory MarketItem.fromRawJson(String str) =>
      MarketItem.fromJson(jsonDecode(str));

  /// 🔁 Convert MarketItem to raw JSON string
  String toRawJson() => jsonEncode(toJson());

  /// 🔁 Encode list of items to raw JSON string
  static String encodeList(List<MarketItem> items) =>
      jsonEncode(items.map((item) => item.toJson()).toList());

  /// 🔁 Decode JSON string to list of MarketItems
  static List<MarketItem> decodeList(String jsonString) =>
      (jsonDecode(jsonString) as List<dynamic>)
          .map((e) => MarketItem.fromJson(e))
          .toList();

  /// ✅ Utility: Get short formatted display date
  String get displayDate => postedAt.split('T').first;

  /// ✅ Utility: Check if the image is available
  bool get hasImage => imagePath.isNotEmpty;
}
