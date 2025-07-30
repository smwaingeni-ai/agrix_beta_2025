/// Enum indicating investor's investment openness
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// ✅ Extension providing label, code, and parsing
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

  /// ✅ Match from status string (for decoding)
  static InvestorStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return InvestorStatus.open;
      case 'notopen':
      case 'not open':
        return InvestorStatus.notOpen;
      case 'indifferent':
        return InvestorStatus.indifferent;
      default:
        return InvestorStatus.indifferent;
    }
  }

  /// ✅ Alias for compatibility
  static InvestorStatus fromName(String status) => fromString(status);
}
