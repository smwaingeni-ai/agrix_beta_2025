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

  /// 🔁 Parse from label (case-insensitive)
  static InvestmentHorizon fromLabel(String label) {
    return InvestmentHorizon.values.firstWhere(
      (e) => e.label.toLowerCase() == label.trim().toLowerCase(),
      orElse: () => InvestmentHorizon.shortTerm,
    );
  }

  /// 🔁 Parse from string (label, code, or name)
  static InvestmentHorizon fromString(String value) {
    final lowerValue = value.trim().toLowerCase();

    return InvestmentHorizon.values.firstWhere(
      (e) =>
          e.label.toLowerCase() == lowerValue ||
          e.code.toLowerCase() == lowerValue ||
          e.name.toLowerCase() == lowerValue,
      orElse: () => InvestmentHorizon.shortTerm,
    );
  }

  /// 📋 All labels for dropdowns
  static List<String> get allLabels =>
      InvestmentHorizon.values.map((e) => e.label).toList();

  /// 📋 All codes for backend
  static List<String> get allCodes =>
      InvestmentHorizon.values.map((e) => e.code).toList();
}

/// ✅ Utility class for external label/string parsing
class InvestmentHorizonUtils {
  static InvestmentHorizon fromLabel(String label) {
    switch (label.trim().toLowerCase()) {
      case 'short-term':
      case 'short term':
        return InvestmentHorizon.shortTerm;
      case 'mid-term':
      case 'mid term':
        return InvestmentHorizon.midTerm;
      case 'long-term':
      case 'long term':
        return InvestmentHorizon.longTerm;
      default:
        return InvestmentHorizon.shortTerm;
    }
  }

  /// Handles any form (enum name, code, label, or hybrid)
  static InvestmentHorizon fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    switch (normalized) {
      case 'shortterm':
        return InvestmentHorizon.shortTerm;
      case 'midterm':
        return InvestmentHorizon.midTerm;
      case 'longterm':
        return InvestmentHorizon.longTerm;
      case 'st':
        return InvestmentHorizon.shortTerm;
      case 'mt':
        return InvestmentHorizon.midTerm;
      case 'lt':
        return InvestmentHorizon.longTerm;
      default:
        return InvestmentHorizon.shortTerm;
    }
  }

  /// For compatibility
  static InvestmentHorizon fromAny(String input) => fromString(input);
}
