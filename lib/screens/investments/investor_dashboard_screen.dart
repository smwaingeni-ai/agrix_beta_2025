import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/investments/investor_profile.dart';
import '../../models/investments/investment_offer.dart';
import '../../models/investments/investment_agreement.dart';
import '../../services/investments/investor_profile_service.dart';
import '../../services/investments/investment_offer_service.dart';

class InvestorDashboardScreen extends StatefulWidget {
  final String investorId;

  const InvestorDashboardScreen({Key? key, required this.investorId})
      : super(key: key);

  @override
  State<InvestorDashboardScreen> createState() => _InvestorDashboardScreenState();
}

class _InvestorDashboardScreenState extends State<InvestorDashboardScreen> {
  InvestorProfile? _profile;
  List<InvestmentOffer> _myOffers = [];
  List<InvestmentAgreement> _myAgreements = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvestorData();
  }

  Future<void> _loadInvestorData() async {
    try {
      final profile = await InvestorProfileService().getInvestorById(widget.investorId);
      final offers = await InvestmentOfferService().getOffersByInvestorId(widget.investorId);
      final agreements = await InvestmentOfferService().getAgreementsByInvestorId(widget.investorId);

      setState(() {
        _profile = profile;
        _myOffers = offers;
        _myAgreements = agreements;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investor Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('Profile not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      _buildOffersSection(),
                      const SizedBox(height: 20),
                      _buildAgreementsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text('Name: ${_profile!.fullName}'),
            Text('Email: ${_profile!.email}'),
            Text('Phone: ${_profile!.phone}'),
            Text('Status: ${_profile!.status}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _profile!.interestAreas.map((area) => Chip(label: Text(area))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Investment Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        if (_myOffers.isEmpty)
          const Text('No offers created yet.')
        else
          Column(
            children: _myOffers.map((offer) {
              return ListTile(
                title: Text(offer.title),
                subtitle: Text('Amount: ${offer.amount} ${offer.currency}'),
                trailing: Text(DateFormat.yMMMd().format(offer.createdAt)),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildAgreementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Investment Agreements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        if (_myAgreements.isEmpty)
          const Text('No agreements signed yet.')
        else
          Column(
            children: _myAgreements.map((agreement) {
              return ListTile(
                title: Text('With ${agreement.farmerName}'),
                subtitle: Text('Amount: ${agreement.amount} ${agreement.currency}'),
                trailing: Text(agreement.status),
              );
            }).toList(),
          ),
      ],
    );
  }
}
