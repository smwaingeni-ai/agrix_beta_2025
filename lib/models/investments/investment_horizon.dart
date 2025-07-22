/// Enum representing investment horizon preferences
enum InvestmentHorizon {
  shortTerm,
  midTerm,
  longTerm,
}

/// Extension to provide label, code, and parsing utilities
extension InvestmentHorizonExtension on InvestmentHorizon {
  /// ✅ Human-readable label for UI display
  String get label {
    switch (this) {
      case InvestmentHorizon.shortTerm:
        return 'Short Term';
      case InvestmentHorizon.midTerm:
        return 'Mid Term';
      case InvestmentHorizon.longTerm:
        return 'Long Term';
    }
  }

  /// ✅ Machine-readable enum code (used for DB/API)
  String get code => name;

  /// ✅ Parse from human-readable label
  static InvestmentHorizon fromLabel(String label) {
    switch (label.trim().toLowerCase()) {
      case 'short term':
        return InvestmentHorizon.shortTerm;
      case 'mid term':
        return InvestmentHorizon.midTerm;
      case 'long term':
        return InvestmentHorizon.longTerm;
      default:
        return InvestmentHorizon.shortTerm; // Safe fallback
    }
  }

  /// ✅ Parse from enum name string (safe for DB/API deserialization)
  static InvestmentHorizon fromName(String name) {
    return InvestmentHorizon.values.firstWhere(
      (e) => e.name.toLowerCase() == name.trim().toLowerCase(),
      orElse: () => InvestmentHorizon.shortTerm,
    );
  }

  /// ✅ Parse from any string (label or enum name)
  static InvestmentHorizon fromString(String value) {
    final parsed = fromLabel(value);
    // If label didn't match and defaulted, try name-based parsing
    return parsed.label.toLowerCase() == value.trim().toLowerCase()
        ? parsed
        : fromName(value);
  }

  /// ✅ Convert all values to label list (useful for UI dropdowns)
  static List<String> get allLabels =>
      InvestmentHorizon.values.map((e) => e.label).toList();

  /// ✅ Convert all values to enum name list (if needed)
  static List<String> get allCodes =>
      InvestmentHorizon.values.map((e) => e.name).toList();
}
