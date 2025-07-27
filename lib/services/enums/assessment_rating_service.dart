// lib/services/enums/assessment_rating_service.dart

import 'package:agrix_beta_2025/models/core/enums/assessment_rating.dart';

/// 🎯 Service for converting between [AssessmentRating] enums and labels
class AssessmentRatingService {
  /// 🔄 Returns all available enum values
  static List<AssessmentRating> getAll() => AssessmentRating.values;

  /// 🏷️ Convert enum to readable label
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
    }
  }

  /// 🔁 Convert label (string) to enum
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
