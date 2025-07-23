class OfficialProfile {
  final String id;
  final String name;
  final String position;
  final String region;
  final String contact;
  final bool isAdmin;

  OfficialProfile({
    required this.id,
    required this.name,
    required this.position,
    required this.region,
    required this.contact,
    required this.isAdmin,
  });

  factory OfficialProfile.fromJson(Map<String, dynamic> json) {
    return OfficialProfile(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      region: json['region'],
      contact: json['contact'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'position': position,
        'region': region,
        'contact': contact,
        'isAdmin': isAdmin,
      };
}
