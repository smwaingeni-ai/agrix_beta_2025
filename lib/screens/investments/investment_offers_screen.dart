import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:agrix_beta_2025/models/investments/investment_offer.dart';
import 'package:agrix_beta_2025/services/market/market_service.dart';

class InvestmentOffersScreen extends StatefulWidget {
  const InvestmentOffersScreen({super.key});

  @override
  State<InvestmentOffersScreen> createState() => _InvestmentOffersScreenState();
}

class _InvestmentOffersScreenState extends State<InvestmentOffersScreen> {
  List<InvestmentOffer> _offers = [];
  bool _loading = true;
  final _currencyFormatter = NumberFormat.simpleCurrency(name: 'USD');

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    setState(() => _loading = true);
    try {
      final offers = await MarketService.loadOffers();
      setState(() {
        _offers = offers;
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching investment offers: $e");
      setState(() {
        _offers = [];
        _loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to load investment offers')),
        );
      }
    }
  }

  Widget _buildOfferCard(InvestmentOffer offer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 ${offer.investorName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (offer.contact.isNotEmpty) Text('📞 ${offer.contact}'),
            Text('💰 Amount: ${_currencyFormatter.format(offer.amount)}'),
            Text('📈 Interest Rate: ${offer.interestRate.toStringAsFixed(2)}%'),
            Text('⏱ Term: ${offer.term.isNotEmpty ? offer.term : 'N/A'}'),
            Text(
              '📊 Status: ${offer.isAccepted ? "✅ Accepted" : "⏳ Pending"}',
              style: TextStyle(
                color: offer.isAccepted ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '🕒 Posted: ${DateFormat.yMMMd().add_jm().format(offer.timestamp)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📞 Contact feature coming soon')),
                  );
                },
                icon: const Icon(Icons.phone_forwarded),
                label: const Text("Contact"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 Investment Offers'),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
              ? const Center(child: Text('🚫 No investment offers available'))
              : RefreshIndicator(
                  onRefresh: _fetchOffers,
                  child: ListView.builder(
                    itemCount: _offers.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) => _buildOfferCard(_offers[index]),
                  ),
                ),
    );
  }
}
