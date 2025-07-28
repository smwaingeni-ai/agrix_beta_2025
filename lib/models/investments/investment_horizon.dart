/// Enum representing investment horizon preferences with duration info
enum InvestmentHorizon {
  shortTerm(months: 6, code: 'ST', label: 'Short Term'),
  midTerm(months: 12, code: 'MT', label: 'Mid Term'),
  longTerm(months: 24, code: 'LT', label: 'Long Term');

  final int months;
  final String code;
  final String label;

  const InvestmentHorizon({
    required this.months,
    required this.code,
    required this.label,
  });

  /// ✅ Parse from label
  static InvestmentHorizon fromLabel(String label) {
    return InvestmentHorizon.values.firstWhere(
      (e) => e.label.toLowerCase() == label.trim().toLowerCase(),
      orElse: () => InvestmentHorizon.shortTerm,
    );
  }

  /// ✅ Parse from enum name or code
  static InvestmentHorizon fromString(String value) {
    final matchByLabel = InvestmentHorizon.values.firstWhere(
      (e) => e.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => InvestmentHorizon.shortTerm,
    );

    // If label didn't match and fallback used, try matching by code or name
    return matchByLabel.label.toLowerCase() == value.trim().toLowerCase()
        ? matchByLabel
        : InvestmentHorizon.values.firstWhere(
            (e) =>
                e.code.toLowerCase() == value.trim().toLowerCase() ||
                e.name.toLowerCase() == value.trim().toLowerCase(),
            orElse: () => InvestmentHorizon.shortTerm,
          );
  }

  /// ✅ All labels (for dropdown display)
  static List<String> get allLabels =>
      InvestmentHorizon.values.map((e) => e.label).toList();

  /// ✅ All codes (for backend/API)
  static List<String> get allCodes =>
      InvestmentHorizon.values.map((e) => e.code).toList();
}
