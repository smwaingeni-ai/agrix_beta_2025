/// Enum defining investor openness status
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// ✅ Extension enabling .label, .fromString, .fromName
extension InvestorStatusExtension on InvestorStatus {
  /// Human-readable UI label
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

  /// Lowercase string code
  String get code => toString().split('.').last;

  /// Decode from string (used in registration, profile JSON, etc.)
  static InvestorStatus fromString(String input) {
    switch (input.toLowerCase()) {
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

  /// Alias for fromString()
  static InvestorStatus fromName(String name) => fromString(name);
}
