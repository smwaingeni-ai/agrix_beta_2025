class SystemStats {
  final int totalFarmers;
  final int totalInvestors;
  final int totalContracts;
  final int totalTasks;
  final int totalPrograms;
  final int totalLogs;
  final DateTime lastSync;

  SystemStats({
    required this.totalFarmers,
    required this.totalInvestors,
    required this.totalContracts,
    required this.totalTasks,
    required this.totalPrograms,
    required this.totalLogs,
    required this.lastSync,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      totalFarmers: json['totalFarmers'] ?? 0,
      totalInvestors: json['totalInvestors'] ?? 0,
      totalContracts: json['totalContracts'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
      totalPrograms: json['totalPrograms'] ?? 0,
      totalLogs: json['totalLogs'] ?? 0,
      lastSync: DateTime.tryParse(json['lastSync'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFarmers': totalFarmers,
      'totalInvestors': totalInvestors,
      'totalContracts': totalContracts,
      'totalTasks': totalTasks,
      'totalPrograms': totalPrograms,
      'totalLogs': totalLogs,
      'lastSync': lastSync.toIso8601String(),
    };
  }
}
