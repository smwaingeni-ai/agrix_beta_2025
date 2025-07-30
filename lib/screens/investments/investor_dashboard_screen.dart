import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:agrix_beta_2025/models/investments/investor_status.dart';
import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';
import 'package:agrix_beta_2025/models/investments/investment_agreement.dart';
import 'package:agrix_beta_2025/services/investments/investor_profile_service.dart';
import 'package:agrix_beta_2025/services/investments/investment_offer_service.dart';

class InvestorDashboardScreen extends StatefulWidget {
  final String investorId;

  const InvestorDashboardScreen({Key? key, required this.investorId}) : super(key: key);

  @override
  State<InvestorDashboardScreen> createState() => _InvestorDashboardScreenState();
}

class _InvestorDashboardScreenState extends State<InvestorDashboardScreen> {
  InvestorProfile? _profile;
  List<InvestmentOffer> _myOffers = [];
  List<InvestmentAgreement> _myAgreements = [];
  bool _isLoading = true;

  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _loadInvestorData();
  }

  Future<void> _loadInvestorData() async {
    try {
      final profile = await InvestorProfileService().getInvestorById(widget.investorId);
      final offers = await InvestmentOfferService.getOffersByInvestorId(widget.investorId);
      final agreements = await InvestmentOfferService.getAgreementsByInvestorId(widget.investorId);

      setState(() {
        _profile = profile;
        _myOffers = offers;
        _myAgreements = agreements;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading investor dashboard: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Investor Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('❌ Investor profile not found'))
              : RefreshIndicator(
                  onRefresh: _loadInvestorData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 24),
                        _buildActionTiles(context),
                        const SizedBox(height: 24),
                        _buildOffersSection(),
                        const SizedBox(height: 24),
                        _buildAgreementsSection(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('👤 Profile Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text('Name: ${_profile!.fullName}'),
            Text('Email: ${_profile!.email}'),
            Text('Phone: ${_profile!.phone}'),
            Text('Status: ${_profile!.status.label}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _profile!.interestAreas.map((area) => Chip(label: Text(area))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTiles(BuildContext context) {
    final List<_DashboardTile> tiles = [
      _DashboardTile(
        label: 'Create Investment Offer',
        icon: Icons.post_add,
        route: '/investment/offer',
      ),
      _DashboardTile(
        label: 'Browse Farmers',
        icon: Icons.people,
        route: '/farmer_directory',
      ),
      _DashboardTile(
        label: 'My Investment Log',
        icon: Icons.history,
        route: '/investment/offers',
      ),
      _DashboardTile(
        label: 'Contracts',
        icon: Icons.assignment_turned_in,
        route: '/contracts/list',
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tiles
          .map((tile) => SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, tile.route),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green[800],
                    padding: const EdgeInsets.all(16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tile.icon, size: 28),
                      const SizedBox(height: 8),
                      Text(tile.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('💼 My Investment Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        if (_myOffers.isEmpty)
          const Text('No offers created yet.')
        else
          ..._myOffers.map((offer) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(offer.title),
                  subtitle: Text('${_currency.format(offer.amount)} • ${offer.term} • ${offer.contact}'),
                  trailing: Text(DateFormat.yMMMd().format(offer.createdAt)),
                ),
              )),
      ],
    );
  }

  Widget _buildAgreementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📃 My Agreements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        if (_myAgreements.isEmpty)
          const Text('No agreements signed yet.')
        else
          ..._myAgreements.map((agreement) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text('With ${agreement.farmerName}'),
                  subtitle: Text(
                    '${_currency.format(agreement.amount)} • ${agreement.currency} • ${DateFormat.yMMMd().format(agreement.startDate)}',
                  ),
                  trailing: Chip(
                    label: Text(agreement.status),
                    backgroundColor: agreement.status == 'Completed'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ),
              )),
      ],
    );
  }
}

class _DashboardTile {
  final String label;
  final IconData icon;
  final String route;

  const _DashboardTile({
    required this.label,
    required this.icon,
    required this.route,
  });
}
