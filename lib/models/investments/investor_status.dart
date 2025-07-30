/// Enum representing an investor's willingness to engage in investment opportunities.
enum InvestorStatus {
  open,
  notOpen,
  indifferent,
}

/// Extension providing human-readable labels, robust parsing, and utility helpers for [InvestorStatus].
extension InvestorStatusExtension on InvestorStatus {
  /// ✅ Human-friendly label for display in UI.
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

  /// ✅ Compact enum name (used in storage, APIs, DB).
  String get code => toString().split('.').last;

  /// 🔁 Parse from enum code (e.g., 'open', 'notOpen').
  static InvestorStatus fromCode(String code) {
    return InvestorStatus.values.firstWhere(
      (e) => e.code.toLowerCase() == code.trim().toLowerCase(),
      orElse: () => InvestorStatus.indifferent,
    );
  }

  /// 🔁 Parse from label (e.g., 'Open', 'Not Open').
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

  /// 🔁 Smart parser that accepts label or code.
  static InvestorStatus fromString(String value) {
    final result = fromLabel(value);
    if (result != InvestorStatus.indifferent || value.toLowerCase() == 'indifferent') {
      return result;
    }
    return fromCode(value);
  }

  /// ✅ Legacy alias for compatibility.
  static InvestorStatus fromName(String value) => fromString(value);

  /// 📋 All status labels for dropdowns or chips.
  static List<String> get allLabels =>
      InvestorStatus.values.map((e) => e.label).toList();

  /// 📋 All enum codes for storage or APIs.
  static List<String> get allCodes =>
      InvestorStatus.values.map((e) => e.code).toList();
}
