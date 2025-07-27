import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/loan/loan_application.dart';
import 'package:agrix_beta_2025/services/loan/loan_application_service.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  List<LoanApplication> _loans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    try {
      final profile = await FarmerProfileService.loadActiveProfile();
      final farmerId = profile?.farmerId;

      if (farmerId == null || farmerId.isEmpty) {
        setState(() {
          _loans = [];
          _loading = false;
        });
        return;
      }

      final allLoans = await LoanApplicationService.loadLoans();
      final filtered = allLoans.where((loan) => loan.farmerId == farmerId).toList();

      setState(() {
        _loans = filtered;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading loans: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load loans.')),
        );
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildLoanCard(LoanApplication loan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.credit_score, color: Colors.green),
        title: Text(
          'ZMW ${loan.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📄 Purpose: ${loan.purpose}'),
              Text('📆 Duration: ${loan.durationMonths} months'),
              Text('📊 Status: ${loan.status}'),
              Text('🕒 Applied: ${DateFormat.yMMMd().format(loan.applicationDate)}'),
            ],
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💼 My Loan Applications')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loans.isEmpty
              ? const Center(child: Text('🚫 No loan applications found.'))
              : RefreshIndicator(
                  onRefresh: _loadLoans,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _loans.length,
                    itemBuilder: (context, index) => _buildLoanCard(_loans[index]),
                  ),
                ),
    );
  }
}
