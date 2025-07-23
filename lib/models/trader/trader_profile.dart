class TraderProfile {
  final String traderId;
  final String fullName;
  final String contact;
  final String region;
  final List<String> categories; // e.g. crops, livestock
  final int numberOfListings;
  final int successfulTrades;
  final double rating;

  TraderProfile({
    required this.traderId,
    required this.fullName,
    required this.contact,
    required this.region,
    required this.categories,
    required this.numberOfListings,
    required this.successfulTrades,
    required this.rating,
  });

  factory TraderProfile.fromJson(Map<String, dynamic> json) {
    return TraderProfile(
      traderId: json['traderId'],
      fullName: json['fullName'],
      contact: json['contact'],
      region: json['region'],
      categories: List<String>.from(json['categories']),
      numberOfListings: json['numberOfListings'],
      successfulTrades: json['successfulTrades'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'traderId': traderId,
      'fullName': fullName,
      'contact': contact,
      'region': region,
      'categories': categories,
      'numberOfListings': numberOfListings,
      'successfulTrades': successfulTrades,
      'rating': rating,
    };
  }
}
