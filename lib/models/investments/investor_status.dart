/// Enum indicating investor status
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// ✅ Extension to expose .label, .code, and parsing
extension InvestorStatusExtension on InvestorStatus {
  String get label {
    switch (this) {
      case InvestorStatus.open:
        return 'Open';
      case InvestorStatus.notOpen:
        return 'Not Open';
      case InvestorStatus.indifferent:
        return 'Indifferent';
    }
  }

  String get code => toString().split('.').last;

  static InvestorStatus fromCode(String code) {
    return InvestorStatus.values.firstWhere(
      (e) => e.toString().split('.').last == code,
      orElse: () => InvestorStatus.indifferent,
    );
  }
}
