import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:agrix_beta_2025/services/contracts/contract_service.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_applications_list.dart';

class ContractListScreen extends StatefulWidget {
  const ContractListScreen({super.key});

  @override
  State<ContractListScreen> createState() => _ContractListScreenState();
}

class _ContractListScreenState extends State<ContractListScreen> {
  late Future<List<ContractOffer>> _contractFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts() {
    _contractFuture = ContractService.loadOffers();
  }

  void _refreshContracts() {
    setState(() {
      _loadContracts();
    });
  }

  void _viewDetails(ContractOffer offer) {
    Navigator.pushNamed(context, '/contracts/detail', arguments: offer);
  }

  void _viewApplicants(ContractOffer offer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContractApplicationsListScreen(offer: offer),
      ),
    );
  }

  Widget _buildContractCard(ContractOffer contract) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.handshake_outlined, color: Colors.teal),
        title: Text(contract.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${contract.cropOrLivestockType} • ${contract.location} • ZMW ${contract.amount.toStringAsFixed(2)}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') _viewDetails(contract);
            if (value == 'applicants') _viewApplicants(contract);
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'details', child: Text('View Details')),
            PopupMenuItem(value: 'applicants', child: Text('View Applicants')),
          ],
        ),
        onTap: () => _viewDetails(contract),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Contract Farming Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Contracts',
            onPressed: _refreshContracts,
          ),
        ],
      ),
      body: FutureBuilder<List<ContractOffer>>(
        future: _contractFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('❌ Failed to load contracts.\n${snapshot.error}'),
            );
          }

          final contracts = snapshot.data ?? [];
          if (contracts.isEmpty) {
            return const Center(child: Text('No contract offers available.'));
          }

          return ListView.builder(
            itemCount: contracts.length,
            itemBuilder: (context, index) => _buildContractCard(contracts[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/contracts/new'),
        tooltip: 'Add Contract Offer',
        child: const Icon(Icons.add),
      ),
    );
  }
}
