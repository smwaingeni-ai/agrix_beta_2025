import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:agrix_beta_2025/models/contracts/contract_application.dart';
import 'package:agrix_beta_2025/services/contracts/contract_application_service.dart';

class ContractApplicationsListScreen extends StatefulWidget {
  final ContractOffer offer;

  const ContractApplicationsListScreen({super.key, required this.offer});

  @override
  State<ContractApplicationsListScreen> createState() =>
      _ContractApplicationsListScreenState();
}

class _ContractApplicationsListScreenState
    extends State<ContractApplicationsListScreen> {
  late Future<List<ContractApplication>> _futureApplications;

  @override
  void initState() {
    super.initState();
    _futureApplications =
        ContractApplicationService().loadApplications(widget.offer.id);
  }

  Widget _buildApplicationCard(ContractApplication app) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.account_circle, color: Colors.green, size: 36),
        title: Text(
          app.farmerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📍 Location: ${app.farmLocation.isNotEmpty ? app.farmLocation : 'N/A'}'),
              Text('📞 Contact: ${app.contactInfo.isNotEmpty ? app.contactInfo : 'N/A'}'),
              if (app.notes.isNotEmpty) Text('📝 Notes: ${app.notes}'),
              Text('📅 Applied: ${app.appliedAt.toLocal().toString().split(' ').first}'),
              Text('🔖 Status: ${app.status}'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    return Scaffold(
      appBar: AppBar(
        title: Text('📑 Applicants for "${offer.title}"'),
      ),
      body: FutureBuilder<List<ContractApplication>>(
        future: _futureApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Failed to load applications.\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No applications submitted yet.'),
            );
          }

          final applications = snapshot.data!;
          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) =>
                _buildApplicationCard(applications[index]),
          );
        },
      ),
    );
  }
}
