enum AssessmentRating {
  excellent,
  good,
  average,
  poor,
}

extension AssessmentRatingExtension on AssessmentRating {
  String get label {
    switch (this) {
      case AssessmentRating.excellent:
        return 'Excellent';
      case AssessmentRating.good:
        return 'Good';
      case AssessmentRating.average:
        return 'Average';
      case AssessmentRating.poor:
        return 'Poor';
    }
  }

  String get value => toString().split('.').last;

  static AssessmentRating fromString(String value) {
    switch (value.toLowerCase()) {
      case 'excellent':
        return AssessmentRating.excellent;
      case 'good':
        return AssessmentRating.good;
      case 'average':
        return AssessmentRating.average;
      case 'poor':
        return AssessmentRating.poor;
      default:
        return AssessmentRating.average;
    }
  }

  static List<String> get labels => AssessmentRating.values.map((e) => e.label).toList();
}
