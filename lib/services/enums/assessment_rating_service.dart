import 'package:agrix_beta_2025/models/core/enums/assessment_rating.dart';

class AssessmentRatingService {
  static List<AssessmentRating> getAll() => AssessmentRating.values;

  static String getLabel(AssessmentRating rating) {
    switch (rating) {
      case AssessmentRating.excellent:
        return 'Excellent';
      case AssessmentRating.good:
        return 'Good';
      case AssessmentRating.average:
        return 'Average';
      case AssessmentRating.poor:
        return 'Poor';
      default:
        return 'Unknown';
    }
  }

  static AssessmentRating? fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'excellent':
        return AssessmentRating.excellent;
      case 'good':
        return AssessmentRating.good;
      case 'average':
        return AssessmentRating.average;
      case 'poor':
        return AssessmentRating.poor;
      default:
        return null;
    }
  }
}
