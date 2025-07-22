// lib/services/investments/investor_match_service.dart

import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';

class InvestorMatchService {
  /// Matches a list of investors with a given investment offer
  List<InvestorProfile> matchInvestorsToOffer({
    required InvestmentOffer offer,
    required List<InvestorProfile> allInvestors,
  }) {
    return allInvestors.where((investor) {
      final interestsMatch = investor.investmentInterests.contains(offer.cropOrLivestockType);
      final statusMatch = investor.investmentStatus == 'Open' || investor.investmentStatus == offer.status;
      final horizonMatch = investor.investmentHorizons.any((h) => h.toLowerCase() == offer.duration.toLowerCase());

      return interestsMatch && statusMatch && horizonMatch;
    }).toList();
  }

  /// Matches a list of investment offers to a given investor profile
  List<InvestmentOffer> matchOffersToInvestor({
    required InvestorProfile investor,
    required List<InvestmentOffer> allOffers,
  }) {
    return allOffers.where((offer) {
      final interestsMatch = investor.investmentInterests.contains(offer.cropOrLivestockType);
      final statusMatch = investor.investmentStatus == 'Open' || investor.investmentStatus == offer.status;
      final horizonMatch = investor.investmentHorizons.any((h) => h.toLowerCase() == offer.duration.toLowerCase());

      return interestsMatch && statusMatch && horizonMatch;
    }).toList();
  }
}
