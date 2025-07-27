import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';

class InvestorMatchService {
  /// 🔍 Match all investors relevant to a specific investment offer
  List<InvestorProfile> matchInvestorsToOffer({
    required InvestmentOffer offer,
    required List<InvestorProfile> allInvestors,
  }) {
    return allInvestors.where((investor) {
      final interestsMatch = investor.investmentInterests.contains(offer.cropOrLivestockType);
      final statusMatch = investor.investmentStatus == 'Open' ||
          investor.investmentStatus.toLowerCase() == offer.status.toLowerCase();
      final horizonMatch = investor.investmentHorizons.any(
        (h) => h.toLowerCase() == offer.duration.toLowerCase(),
      );

      return interestsMatch && statusMatch && horizonMatch;
    }).toList();
  }

  /// 🔍 Match all investment offers relevant to a specific investor
  List<InvestmentOffer> matchOffersToInvestor({
    required InvestorProfile investor,
    required List<InvestmentOffer> allOffers,
  }) {
    return allOffers.where((offer) {
      final interestsMatch = investor.investmentInterests.contains(offer.cropOrLivestockType);
      final statusMatch = investor.investmentStatus == 'Open' ||
          investor.investmentStatus.toLowerCase() == offer.status.toLowerCase();
      final horizonMatch = investor.investmentHorizons.any(
        (h) => h.toLowerCase() == offer.duration.toLowerCase(),
      );

      return interestsMatch && statusMatch && horizonMatch;
    }).toList();
  }
}
