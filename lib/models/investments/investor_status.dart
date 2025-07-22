/// Enum representing an investor's willingness to engage in investment opportunities.
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// Extension providing human-readable labels and robust utility methods.
extension InvestorStatusExtension on InvestorStatus {
  /// Human-friendly label for display in UI
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

  /// Compact string for storage, API, or local DB
  String get code => name;

  /// 🔁 Parse from code (enum name string)
  static InvestorStatus fromCode(String code) {
    return InvestorStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == code.trim().toLowerCase(),
      orElse: () => InvestorStatus.indifferent,
    );
  }

  /// 🔁 Parse from label (human-readable string)
  static InvestorStatus fromLabel(String label) {
    final normalized = label.trim().toLowerCase();
    switch (normalized) {
      case 'open':
      case 'open to investment':
        return InvestorStatus.open;
      case 'not open':
      case 'closed':
        return InvestorStatus.notOpen;
      case 'indifferent':
      default:
        return InvestorStatus.indifferent;
    }
  }

  /// 🔁 General string parser (label or code)
  static InvestorStatus fromString(String value) {
    final result = fromLabel(value);
    if (result != InvestorStatus.indifferent || value.toLowerCase() == 'indifferent') {
      return result;
    }
    return fromCode(value);
  }

  /// 🔁 All status labels (for dropdowns/chips)
  static List<String> get allLabels =>
      InvestorStatus.values.map((e) => e.label).toList();

  /// 🔁 All enum codes (for DB/API)
  static List<String> get allCodes =>
      InvestorStatus.values.map((e) => e.code).toList();
}
