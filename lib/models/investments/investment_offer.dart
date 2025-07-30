/// Enum representing an investor's willingness to engage in investment opportunities.
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// Extension providing human-readable labels and robust utility methods.
extension InvestorStatusExtension on InvestorStatus {
  /// Get a display-friendly label
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

  /// Parse from string (name or label)
  static InvestorStatus fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'open':
        return InvestorStatus.open;
      case 'not open':
      case 'notopen':
        return InvestorStatus.notOpen;
      case 'indifferent':
      default:
        return InvestorStatus.indifferent;
    }
  }

  /// Parse from enum name string
  static InvestorStatus fromName(String name) {
    return InvestorStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => InvestorStatus.indifferent,
    );
  }
}
