class SystemStats {
  final int totalUsers;
  final int activeFarmers;
  final int marketItems;
  final int pendingLoans;

  const SystemStats({
    required this.totalUsers,
    required this.activeFarmers,
    required this.marketItems,
    required this.pendingLoans,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      totalUsers: json['totalUsers'] ?? 0,
      activeFarmers: json['activeFarmers'] ?? 0,
      marketItems: json['marketItems'] ?? 0,
      pendingLoans: json['pendingLoans'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalUsers': totalUsers,
        'activeFarmers': activeFarmers,
        'marketItems': marketItems,
        'pendingLoans': pendingLoans,
      };
}
