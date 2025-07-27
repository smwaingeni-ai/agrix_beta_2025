import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _loadApplications();
  }

  void _loadApplications() {
    _futureApplications =
        ContractApplicationService().loadApplications(widget.offer.id);
  }

  Future<void> _refreshApplications() async {
    setState(() {
      _loadApplications();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _buildApplicationCard(ContractApplication app) {
    final appliedDate = DateFormat('dd MMM yyyy').format(app.appliedAt.toLocal());

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.account_circle, color: Colors.green, size: 36),
        title: Text(
          app.farmerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📍 Location: ${app.location.isNotEmpty ? app.location : 'N/A'}'),
              Text('📞 Contact: ${app.phoneNumber.isNotEmpty ? app.phoneNumber : 'N/A'}'),
              if (app.motivation.isNotEmpty)
                Text('📝 Motivation: ${app.motivation}'),
              Text('📅 Applied: $appliedDate'),
              Text(
                '🔖 Status: ${app.status}',
                style: TextStyle(
                  color: _getStatusColor(app.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📑 Applicants for "${widget.offer.title}"'),
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
          return RefreshIndicator(
            onRefresh: _refreshApplications,
            child: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) =>
                  _buildApplicationCard(applications[index]),
            ),
          );
        },
      ),
    );
  }
}
