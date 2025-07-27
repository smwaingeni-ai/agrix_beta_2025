import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:agrix_beta_2025/services/contracts/contract_offer_service.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_offer_form.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_applications_list.dart';

class ContractsDashboardScreen extends StatefulWidget {
  const ContractsDashboardScreen({super.key});

  @override
  State<ContractsDashboardScreen> createState() => _ContractsDashboardScreenState();
}

class _ContractsDashboardScreenState extends State<ContractsDashboardScreen> {
  List<ContractOffer> _offers = [];
  bool _loading = true;
  final _currencyFormat = NumberFormat.simpleCurrency(name: 'ZMW');

  @override
  void initState() {
    super.initState();
    _fetchContractOffers();
  }

  Future<void> _fetchContractOffers() async {
    setState(() => _loading = true);
    try {
      final offers = await ContractOfferService().loadOffers();
      setState(() {
        _offers = offers;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to load contract offers: $e')),
      );
    }
  }

  void _navigateToOfferForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContractOfferForm()),
    );
    _fetchContractOffers(); // 🔄 Refresh after new offer added
  }

  void _openApplications(ContractOffer offer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContractApplicationsListScreen(offer: offer),
      ),
    );
  }

  Widget _buildContractCard(ContractOffer offer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          offer.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('📍 Location: ${offer.location}'),
            Text('💰 Amount: ${_currencyFormat.format(offer.amount)}'),
            Text('📆 Duration: ${offer.duration}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.group, color: Colors.green),
          tooltip: 'View Applicants',
          onPressed: () => _openApplications(offer),
        ),
        onTap: () => _openApplications(offer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Contract Offers Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchContractOffers,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
              ? const Center(
                  child: Text(
                    '📭 No contract offers available.\nTap "+" to create one.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _offers.length,
                  itemBuilder: (context, index) => _buildContractCard(_offers[index]),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToOfferForm,
        icon: const Icon(Icons.add),
        label: const Text('New Offer'),
      ),
    );
  }
}
